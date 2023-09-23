import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_words/models/words_model.dart';
import 'package:my_words/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LearningStatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColor.primaryBackGroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.learning_statistic,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ConstantsColor.primaryColor,
      ),
      body: FutureBuilder(
        future: Provider.of<WordsModel>(context, listen: false).init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<WordsModel>(
              builder: (context, wordsModel, child) {
                if (wordsModel.learningStats.isEmpty) {
                  return const Center(
                      child: Text('Henüz istatistik verisi bulunmuyor.'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /*Text(
                          AppLocalizations.of(context)!.words_learned_over_time,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),*/
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Color(0xffFFC6D0),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 30.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: _buildLearningStatsChart(
                                  wordsModel.learningStats),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            return const Center(child: Text('Bir hata oluştu.'));
          }
        },
      ),
    );
  }

  Widget _buildLearningStatsChart(Map<DateTime, int> learningStats) {
    final sortedKeys = learningStats.keys.toList()..sort();
    final List<BarChartGroupData> data = [];
    final last10Days = sortedKeys.length >= 10
        ? sortedKeys.sublist(sortedKeys.length - 10, sortedKeys.length)
        : sortedKeys;
    for (int i = 0; i < last10Days.length; i++) {
      final date = last10Days[i];
      final count = learningStats[date];
      data.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            y: count!.toDouble(),
            width: 22,
            colors: [ConstantsColor.primaryColor],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ],
      ));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: (learningStats.values.toList()..sort()).last.toDouble() + 1,
        minY: 0,
        groupsSpace: 3,
        barTouchData: BarTouchData(enabled: true),
        barGroups: data.toList(),
        gridData: FlGridData(
            drawVerticalLine: false,
            checkToShowHorizontalLine: (value) => value % 1 == 0,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(
                  color: ConstantsColor.primaryColor,
                  strokeWidth: 3,
                );
              } else {
                return FlLine(
                  color: ConstantsColor.primaryColor,
                  strokeWidth: 0.6,
                );
              }
            }),
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (contex, value) => const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
            getTitles: (double value) {
              if (value % 1 == 0) {
                return value.toInt().toString();
              } else {
                return '';
              }
            },
          ),
          rightTitles: SideTitles(
            showTitles: true,
            getTextStyles: (contex, value) => const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
            getTitles: (double value) {
              if (value % 1 == 0) {
                return value.toInt().toString();
              } else {
                return '';
              }
            },
          ),
          topTitles: SideTitles(
            showTitles: false,
          ),
          bottomTitles: SideTitles(
            rotateAngle: -90,
            showTitles: true,
            getTextStyles: (contex, value) => const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
            getTitles: (double value) {
              final int index = value.toInt();
              if (index >= 0 && index < last10Days.length) {
                final date = last10Days[index];
                return '${date.day}.${date.month}.${date.year}';
              } else {
                return '';
              }
            },
            margin: 8,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }
}
