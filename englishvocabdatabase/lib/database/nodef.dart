/*
database method
Future<Database> initDatabase();
Future<Database> getDBConnect();
Future<bool> hasNoDef(int id);
Future<bool> addNoDef(String name);
Future<List<NoDefinition>?> getAllNoDefs();

start從0開始，然後是左閉右開，所以start=0, end=1會顯示第一個元素
Future<List<NoDefinition>?> getSomeNoDefs({required int start, int? end, String? sortColumn});

Future<void> deleteNoDef(int id);
Future<List<NoDefinition>?> searchNoDef(String prefix);
Future<int> getNoDefid(String name);
*/

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/widgets.dart';
import 'wordModifyInformation.dart';

class NoDefinition{

  late int _id;
  late String _name;
  late String _definition = '';
  late String _parts = '';   //詞性
  String? _chinese = '';
  late String _sentence = '';

  NoDefinition({required int id, required String name, String? definition, String? parts, String? chinese, String? sentence}){
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
  }

  Map<String, Object?> toMap() {
    return {'id': _id, 'name': _name, 'definition': _definition, 'parts': _parts, 'chinese':_chinese, 'sentence':_sentence};
  }

  @override
  String toString() {
    return 'NoDefinition{id: $_id, name: $_name, definition: $_definition, parts: $_parts, chinese: $_chinese, sentence: $_sentence}';
  }

  int get id => _id;
  String get name => _name;
}
