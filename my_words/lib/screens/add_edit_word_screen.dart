import 'package:flutter/material.dart';
import 'package:my_words/models/word.dart';

import 'package:provider/provider.dart';

import '../models/words_model.dart';

class EditWordScreen extends StatefulWidget {
  final Word word;
  final int index;

  EditWordScreen({required this.word, required this.index});

  @override
  _EditWordScreenState createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<EditWordScreen> {
  final _formKey = GlobalKey<FormState>();

  String _english = '';
  String _turkish = '';
  String _example = '';

  @override
  void initState() {
    super.initState();

    _english = widget.word.english;
    _turkish = widget.word.turkish;
    _example = widget.word.example;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedWord = Word(
          id: widget.word.id,
          english: _english,
          turkish: _turkish,
          example: _example,
          createdAt: widget.word.createdAt,
          isFavorite: widget.word.isFavorite,
          category: widget.word.category);

      Provider.of<WordsModel>(context, listen: false)
          .updateWord(updatedWord, widget.index);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    initialValue: _english,
                    decoration: InputDecoration(
                      labelText: 'English',
                      helperText: 'Enter the English version of the word',
                      errorText: 'Please enter the English version of the word',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the English version of the word.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _english = value!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    initialValue: _turkish,
                    decoration: InputDecoration(
                      labelText: 'Turkish',
                      helperText: 'Enter the Turkish version of the word',
                      errorText: 'Please enter the Turkish version of the word',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the Turkish version of the word.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _turkish = value!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    initialValue: _example,
                    decoration: InputDecoration(
                      labelText: 'Example',
                      helperText: 'Enter an example sentence using the word',
                      errorText: 'Please enter an example of the word',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an example of the word.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _example = value!;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
