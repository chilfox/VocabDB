import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/widgets.dart';
import 'wordModifyInformation.dart';
import 'wordFilterOption.dart';

class Word{

  late int _id;
  late String _name;
  late String _definition = '';
  late String _parts = '';   //詞性
  String? _chinese = '';
  late String _sentence = '';
  List<String>? _labels = null;

  Word({required int id, required String name, String? definition, String? parts, String? chinese, String? sentence, List<String>? labels}){
    _id = id;
    _name = name;
    if(definition != null){
      _definition = definition;
    }
    if(parts != null){
      _parts = parts;
    }
    if(chinese != null){
      _chinese = chinese;
    }
    if(sentence != null){
      _sentence = sentence;
    }
    if(labels != null){
      _labels = labels;
    }
  }

  Map<String, Object?> toMap() {
    return {'id': _id, 'name': _name, 'definition': _definition, 'parts': _parts, 'chinese':_chinese, 'sentence':_sentence};
  }

  @override
  String toString() {
    return 'Word{id: $_id, name: $_name, definition: $_definition, parts: $_parts, chinese: $_chinese, sentence: $_sentence}';
  }

  int get id => _id;
  String get name => _name;
  String? get chinese => _chinese;
  String? get definition => _definition;
  String get parts => _parts;
  String get sentence => _sentence;

  List<String>? get labels => _labels;
  void set_labels(List<String>? list){
    _labels = list;
  }
}
