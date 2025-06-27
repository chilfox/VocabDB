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

  String Getname(){
    return _name;
  }

  void Setname(String x){
    _name = x;
    return;
  }

  int Getwordnum(){
    return _wordnum;
  }

  void Setwordnum(int x){
    _wordnum = x;
    return;
  }

  int Getid(){
    return _id;
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
