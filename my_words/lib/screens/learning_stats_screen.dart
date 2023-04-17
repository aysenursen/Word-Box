import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';

class LearningStatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Öğrenme İstatistiği',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder(
        future: Provider.of<WordsModel>(context, listen: false).init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<WordsModel>(
              builder: (context, wordsModel, child) {
                if (wordsModel.learningStats.isEmpty) {
                  return Center(
                      child: Text('Henüz istatistik verisi bulunmuyor.'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Zaman İçinde Öğrenilen Kelimeler',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: _buildLearningStatsChart(
                              wordsModel.learningStats),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            return Center(child: Text('Bir hata oluştu.'));
          }
        },
      ),
    );
  }

  Widget _buildLearningStatsChart(Map<DateTime, int> learningStats) {
    final sortedKeys = learningStats.keys.toList()..sort();
        final List<FlSpot> data = [];

    for (int i = 0; i < sortedKeys.length; i++) {
      final date = sortedKeys[i];
      final count = learningStats[date];
      data.add(FlSpot(i.toDouble(), count!.toDouble()));
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (sortedKeys.length - 1).toDouble(),
        minY: 0,
        maxY: (learningStats.values.toList()..sort()).last.toDouble() + 1,
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            barWidth: 3,
            colors: [Colors.purple],
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                color: Colors.purple,
                radius: 4,
              ),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (contex, value) => TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (contex, value) => TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
            getTitles: (double value) {
              final int index = value.toInt();
              if (index >= 0 && index < sortedKeys.length) {
                final date = sortedKeys[index];
                return '${date.day}.${date.month}.${date.year}';
              } else {
                return '';
              }
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }
}

