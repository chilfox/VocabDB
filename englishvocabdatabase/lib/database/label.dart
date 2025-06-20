import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/widgets.dart';
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


class LabelDB {
  int _id = 1;
  static Database? database;
  static Future<Database> initDatabase() async {
      final database = await openDatabase(

      join(await getDatabasesPath(), 'label_database.db'),
  
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE labels(id INTEGER, name TEXT PRIMARY KEY, wordnum INTEGER)',
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

  Future<bool> hasLabel({int? id, String? label}) async {
    final db = await getDBConnect();
    assert(id != null || label != null);
    if(label != null){
      final List<Map<String, Object?>> result = await db.query(
        'labels',
        where: 'name = ?',
        whereArgs: [label],
        limit: 1, 
      );
      return result.isNotEmpty;
    }
    else if(id != null){
      final List<Map<String, Object?>> result = await db.query(
        'labels',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1, 
      );
      return result.isNotEmpty;
    }
    return false;
  }

  Future<bool> addLabel(String label) async {

    final db = await getDBConnect();
    
    if(await hasLabel(label: label)){
      return false;
    }

    var insertinglabel = Label(id: _id, name: label, wordnum: 0);

    await db.insert(
      'labels',
      insertinglabel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _id += 1;
    return true;
  }

  Future<List<Label>?> getAllLabels() async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> labelMaps = await db.query('labels');

    return [
      for (final {'id': id as int, 'name': name as String, 'wordnum': wordnum as int}
          in labelMaps)
        Label(id: id, name: name, wordnum: wordnum),
    ];
  }

  Future<List<Label>?> getSomeLabels({required int start, int? end, String? sortColumn}) async{
    //sortColumn 放 name, wordnum, 或id
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
      'labels',
      orderBy: orderBy,
    );

    if(maps.isEmpty){
      return [];
    }

    final List<Label> result = List.generate(maps.length, (i){
      return Label(id: maps[i]['id'], name: maps[i]['name'], wordnum: maps[i]['wordnum']);
    }); 

    if(start >= result.length){
      return null;
    }    
    if(end == null || end >= result.length){
      end = result.length;
    }

    return result.sublist(start, end);
  }

  Future<void> deleteLabel({String? label, int? id}) async {
    final db = await getDBConnect();
    if(label != null){
      await db.delete(
        'labels',
        where: 'name = ?',
        whereArgs: [label],
      );
    }
    else if (id != null){
      await db.delete(
        'labels',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }


  Future<List<Label>?> searchLabel(String prefix) async{
    final db = await getDBConnect();

    List<Map<String, Object?>> results = await db.query(
      'labels',
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
      for (final {'id': id as int, 'name': name as String, 'wordnum': wordnum as int}
          in changeable)
        Label(id: id, name: name, wordnum: wordnum),
    ];
  }

  Future<int> getLabelid(String label) async{
      final db = await getDBConnect();
      final List<Map<String, Object?>> result = await db.query(
      'labels',
      where: 'name = ?',
      whereArgs: [label],
      limit: 1, 
      );
      if(result.isEmpty){
        return -1;
      }
      return result[0]['id'] as int;
  }

  Future<void> updateLabel(String label, int wordnum) async{
    final db = await getDBConnect();

    int id = await getLabelid(label);
    if(id == -1){
      return;
    }

    var temp = Label(id: id, name: label, wordnum: wordnum);

    await db.update(
      'labels',
      temp.toMap(),
      where:'name = ?',
      whereArgs: [label],
    );
  }
}



/*
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var db = LabelDB();
  await db.addLabel("hi");

  await db.addLabel("hi2");

  await db.addLabel("hi4");

  await db.addLabel("hi3");
  
  if(await db.hasLabel(id: 10)){
    print("true");
  }
  print(await db.getAllLabels());

  print(await db.getSomeLabels(start: 1, sortColumn: "name"));

}
*/