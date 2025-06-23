/*
database method
Future<Database> initDatabase();
Future<Database> getDBConnect();
Future<bool> hasNoDef({int? id, String? name});
Future<bool> addNoDef(String name);
Future<List<NoDefinition>?> getAllNoDefs();

start從0開始，然後是左閉右開，所以start=0, end=1會顯示第一個元素
Future<List<NoDefinition>?> getSomeNoDefs({required int start, int? end, String? sortColumn});

Future<void> deleteNoDef({String? name, int? id});
Future<List<NoDefinition>?> searchNoDef(String prefix);
Future<int> getNoDefid(String name);
*/

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/widgets.dart';


class WordModifyInformation{
    late String _column;
    late String _newInformation;
    
    WordModifyInformation({required String column, required String newInformation}){
      _column = column;
      _newInformation = newInformation;
    }

    String Getcolumn(){
      return _column;
    }

    void Setcolumn(String x){
      _column = x;
      return;
    }

    String Getinformation(){
      return _newInformation;
    }

    void Setinformation(String x){
      _newInformation = x;
      return;
    }
}

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
}

class NoDefDB {
  int _id = 0;
  static Database? database;
  static Future<Database> initDatabase() async {
      final database = await openDatabase(

      join(await getDatabasesPath(), 'nodefinition_database.db'),
  
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE nodefs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, definition TEXT, parts TEXT, chinese TEXT, sentence TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  static Future<Database> getDBConnect() async {
    if (database != null) {
      return database!;
    }
    return await initDatabase();
  }

  Future<bool> hasNoDef(int id) async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> result = await db.query(
      'nodefs',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, 
    );
    return result.isNotEmpty;
  }

  Future<bool> addNoDef(String name) async {

    final db = await getDBConnect();
    
    final Map<String, dynamic> insertingnodef = {
      'name': name,
      'definition': '',
      'parts': '',
      'chinese': '',
      'sentence': '', 
    };

    await db.insert(
      'nodefs',
      insertingnodef,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<List<NoDefinition>?> getAllNoDefs() async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> nodefMaps = await db.query('nodefs');

    return [
      for (final {'id': id as int, 'name': name as String}
          in nodefMaps)
        NoDefinition(id: id, name: name),
    ];
  }

  Future<List<NoDefinition>?> getSomeNoDefs({required int start, int? end, String? sortColumn}) async{
    //sortColumn 放 name, id, definition, parts, chinese, sentence
    //如果沒有end，會把end判斷成結尾
    //start從0開始，然後是左閉右開，所以start=0, end=1會顯示第一個元素
    //end最多是list的length
    final db = await getDBConnect();

    if(end != null){
      assert(start <= end);
    }
    String orderBy = 'null';
    if(sortColumn != null){
      orderBy = '$sortColumn ASC';
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'nodefs',
      orderBy: orderBy,
    );

    if(maps.isEmpty){
      return [];
    }

    final List<NoDefinition> result = List.generate(maps.length, (i){
      return NoDefinition(id: maps[i]['id'], name: maps[i]['name']);
    }); 

    if(start >= result.length){
      return null;
    }    
    if(end == null || end >= result.length){
      end = result.length;
    }

    return result.sublist(start, end);
  }

  Future<void> deleteNoDef(int id) async {
    final db = await getDBConnect();
    await db.delete(
      'nodefs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<List<NoDefinition>?> searchNoDef(String prefix) async {
    final db = await getDBConnect();

    List<Map<String, Object?>> results = await db.query(
      'nodefs',
      where: 'name LIKE ?',
      whereArgs: ['$prefix%'], 
    );

    List<Map<String, Object?>> changeable = List.from(results);
    changeable.sort((a, b){
      final String namea = a['name'] as String;
      final String nameb = b['name'] as String;
      return namea.compareTo(nameb);
    });
    return [
      for (final {'id': id as int, 'name': name as String}
          in changeable)
        NoDefinition(id: id, name: name),
    ];
  }

  Future<List<int>> getNoDefid(List<WordModifyInformation> conditions) async {
      final db = await getDBConnect();
      List<String> clauseParts = [];
      String whereClause = '';
      List<dynamic> whereArgs = [];
      assert(conditions.isNotEmpty);
      for(var condition in conditions){
        var key = condition._column;
        var value = condition._newInformation;
        clauseParts.add('$key = ?');
        whereArgs.add(value);
      }
      whereClause = clauseParts.join(' AND ');

      final List<Map<String, Object?>> results = await db.query(
        'nodefs',
        columns: ['id'], 
        where: whereClause.isEmpty ? null : whereClause,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
      );
      return [
        for (final {'id': id as int} in results)
        id,
      ];
  }

  Future<NoDefinition?> searchNoDefDetails(int id) async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> result = await db.query(
        'nodefs',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1, 
      );
    if(result.isNotEmpty){
        var ans = NoDefinition(id: result[0]['id'] as int, name: result[0]['name'] as String, definition: result[0]['definition'] as String, parts: result[0]['parts'] as String, chinese: result[0]['chinese'] as String, sentence: result[0]['sentence'] as String);
        return ans;
    }
    return null;
  }

  Future<void> updateNoDef(int id, WordModifyInformation newData) async{
    final db = await getDBConnect();
    if(!(await hasNoDef(id))){
        return;
    }
    var information = await searchNoDefDetails(id);
    var column = newData._column;
    var newInformation = newData._newInformation;
    assert(column != 'id');
    await db.update(
      'nodefs',
      {
        column: newInformation,
      },
      where:'id = ?',
      whereArgs: [id],
    );
    return;
  }
}

/*
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var db = NoDefDB();
  /*
  await db.addNoDef("hi");

  await db.addNoDef("hi2");

  await db.addNoDef("hi4");

  await db.addNoDef("hi3");
  
  if(await db.hasNoDef(10)){
    print("true");
  }

  NoDefinition? temp = await db.searchNoDefDetails(3);
  if(temp != null){
    print(temp.toString());
  }
  print(await db.getSomeNoDefs(start: 1, sortColumn: "name"));


  print(await db.getAllNoDefs());
  var h3 = WordModifyInformation(column: "name", newInformation: "hi3");
  var ids = WordModifyInformation(column: "id", newInformation: "12");
  List<WordModifyInformation> list = [h3, ids];
  List<int> result = await db.getNoDefid(list);
  for(var item in result){
    print(item);
  }
  */

  NoDefinition? temp = await db.searchNoDefDetails(3);
  if(temp != null){
    print(temp.toString());
  }
  var modify = WordModifyInformation(column: 'name', newInformation: 'blablabla');
  await db.updateNoDef(3, modify);
  temp = await db.searchNoDefDetails(3);
  if(temp != null){
    print(temp.toString());
  }
}
*/