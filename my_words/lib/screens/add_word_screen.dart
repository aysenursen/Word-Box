import 'package:flutter/material.dart';
import 'package:my_words/models/word.dart';

import 'package:provider/provider.dart';

import '../models/words_model.dart';

class AddWordScreen extends StatefulWidget {
  final Word? editWord;
  final int? editIndex;
  AddWordScreen({this.editWord, this.editIndex});
  @override
  _AddWordScreenState createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _englishController = TextEditingController();
  final _turkishController = TextEditingController();
  final _exampleController = TextEditingController();

  void _saveWord() {
    if (_formKey.currentState!.validate()) {
      final newWord = Word(
        id: DateTime.now().millisecondsSinceEpoch,
        english: _englishController.text,
        turkish: _turkishController.text,
        example: _exampleController.text,
        createdAt: DateTime.now(),
      );
      Provider.of<WordsModel>(context, listen: false).addWord(newWord, context);
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.purple, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yeni Kelime Ekle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _englishController,
                decoration: _inputDecoration(labelText: 'İngilizce'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir değer girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _turkishController,
                decoration: _inputDecoration(labelText: 'Türkçe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir değer girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _exampleController,
                decoration: _inputDecoration(labelText: 'Örnek Cümle'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir değer girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveWord,
                  child: Text('Kaydet'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}