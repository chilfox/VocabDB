import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Label {
  late int _id;
  late String _name;
  late int _wordnum;

  Label({required int id, required String name, required int wordnum}){
    _id = id;
    _name = name;
    _wordnum = wordnum;
  }

  int get id => _id;
  String get name => _name;
  int get wordnum => _wordnum;

  void Setname(String x){
    _name = x;
    return;
  }

  void Setwordnum(int x){
    _wordnum = x;
    return;
  }

  void Setid(int x){
    _id = x;
    return;
  }

  Map<String, Object?> toMap() {
    return {'id': _id, 'name': _name, 'wordnum': _wordnum};
  }

  @override
  String toString() {
    return 'Label{id: $_id, name: $_name, wordnum: $_wordnum}';
  }
}
