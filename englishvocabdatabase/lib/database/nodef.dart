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
class NoDefinition{

    late int _id;
    late String _name;

  NoDefinition({required int id, required String name}){
    _id = id;
    _name = name;
  }

  String Getname(){
    return _name;
  }

  void Setname(String x){
    _name = x;
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
    return {'id': _id, 'name': _name};
  }

  @override
  String toString() {
    return 'NoDef{id: $_id, name: $_name}';
  }
}

class NoDefDB {
  int _id = 1;
  static Database? database;
  static Future<Database> initDatabase() async {
      final database = await openDatabase(

      join(await getDatabasesPath(), 'nodefinition_database.db'),
  
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE nodefs(id INTEGER, name TEXT PRIMARY KEY)',
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

  Future<bool> hasNoDef({int? id, String? name}) async {
    final db = await getDBConnect();
    assert(id != null || name != null);
    if(name != null){
      final List<Map<String, Object?>> result = await db.query(
        'nodefs',
        where: 'name = ?',
        whereArgs: [name],
        limit: 1, 
      );
      return result.isNotEmpty;
    }
    else if(id != null){
      final List<Map<String, Object?>> result = await db.query(
        'nodefs',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1, 
      );
      return result.isNotEmpty;
    }
    return false;
  }

  Future<bool> addNoDef(String name) async {

    final db = await getDBConnect();
    
    if(await hasNoDef(name: name)){
      return false;
    }

    var insertingnodef = NoDefinition(id: _id, name: name);

    await db.insert(
      'nodefs',
      insertingnodef.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _id += 1;
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
    //sortColumn 放 name, 或id
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

  Future<void> deleteNoDef({String? name, int? id}) async {
    final db = await getDBConnect();
    if(name != null){
      await db.delete(
        'nodefs',
        where: 'name = ?',
        whereArgs: [name],
      );
    }
    else if (id != null){
      await db.delete(
        'nodefs',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
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

  Future<int> getNoDefid(String name) async {
      final db = await getDBConnect();
      final List<Map<String, Object?>> result = await db.query(
      'nodefs',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1, 
      );
      if(result.isEmpty){
        return -1;
      }
      return result[0]['id'] as int;
  }

}

/*
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var db = NoDefDB();
  await db.addNoDef("hi");

  await db.addNoDef("hi2");

  await db.addNoDef("hi4");

  await db.addNoDef("hi3");
  
  if(await db.hasNoDef(id: 10)){
    print("true");
  }
  print(await db.getAllNoDefs());

  print(await db.getSomeNoDefs(start: 1, sortColumn: "name"));

}
*/