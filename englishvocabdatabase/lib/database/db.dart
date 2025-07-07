import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'wordModifyInformation.dart';
import 'wordFilterOption.dart';
import 'nodef.dart';
import 'word.dart';
import 'label.dart';

class DB {
  static Database? database;
// init and connect
  static Future<Database> initDatabase() async {
      final database = await openDatabase(

      join(await getDatabasesPath(), 'database.db'),
  
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE labels(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, wordnum INTEGER)',
        );

        //add nolabel
        await db.insert(
            'labels',
            {
              'name': 'nolabel',
              'wordnum': 0,
            },
          );

        await db.execute(
          'CREATE TABLE nodefs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, definition TEXT, parts TEXT, chinese TEXT, sentence TEXT)',
        );
        await db.execute(
          'CREATE TABLE words(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, definition TEXT, parts TEXT, chinese TEXT, sentence TEXT)',
        );
        await db.execute(
          'CREATE TABLE label_lists(id INTEGER, label TEXT, PRIMARY KEY (id, label), FOREIGN KEY (id) REFERENCES words(id) ON DELETE CASCADE)',
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

// label
  static Future<bool> hasLabel({int? id, String? label}) async {
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

  static Future<int> addLabel(String label) async {

    final db = await getDBConnect();
    
    if(await hasLabel(label: label)){
      return -1;
    }

    final Map<String, dynamic> insertinglabel = {
      'name': label,
      'wordnum': 0, 
    };

    final int newid = await db.insert(
      'labels',
      insertinglabel,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return newid;
  }

  static Future<List<Label>?> getAllLabels() async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> labelMaps = await db.query('labels');

    return [
      for (final {'id': id as int, 'name': name as String, 'wordnum': wordnum as int}
          in labelMaps)
        Label(id: id, name: name, wordnum: wordnum),
    ];
  }

  static Future<List<Label>?> getSomeLabels({required int start, int? end, String? sortColumn}) async{
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

  static Future<void> deleteLabel({String? label, int? id}) async {
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

  static Future<List<Label>?> searchLabel(String prefix) async{
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

  static Future<int> getLabelid(String label) async{
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

  //modify by cwh
  static Future<String?> getLabelname(int id) async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> result = await db.query(
      'labels',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return result[0]['name'] as String;
  }

  static Future<void> updateLabel(String label, int wordnum) async{
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

// nodef
  static Future<bool> hasNoDef(int id) async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> result = await db.query(
      'nodefs',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, 
    );
    return result.isNotEmpty;
  }

  static Future<int> addNoDef(String name) async {

    final db = await getDBConnect();
    
    final Map<String, dynamic> insertingnodef = {
      'name': name,
      'definition': '',
      'parts': '',
      'chinese': '',
      'sentence': '', 
    };

    final int newid = await db.insert(
      'nodefs',
      insertingnodef,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return newid;
  }

  static Future<List<NoDefinition>?> getAllNoDefs() async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> nodefMaps = await db.query('nodefs');

    return [
      for (final {'id': id as int, 'name': name as String}
          in nodefMaps)
        NoDefinition(id: id, name: name),
    ];
  }

  static Future<List<NoDefinition>?> getSomeNoDefs({required int start, int? end, String? sortColumn}) async{
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

  static Future<void> deleteNoDef(int id) async {
    final db = await getDBConnect();
    await db.delete(
      'nodefs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //return list of id with prefix name
  static Future<List<NoDefinition>?> searchNoDef(String prefix) async {
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

  //return list of id that satisfies the requirement
  static Future<List<int>> getNoDefid(List<WordModifyInformation> conditions) async {
      final db = await getDBConnect();
      List<String> clauseParts = [];
      String whereClause = '';
      List<dynamic> whereArgs = [];
      assert(conditions.isNotEmpty);
      for(var condition in conditions){
        var key = condition.column;
        var value = condition.newInformation;
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

  //if not find will return null
  static Future<NoDefinition?> searchNoDefDetails(int id) async {
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

  static Future<void> updateNoDef(int id, WordModifyInformation newData) async{
    final db = await getDBConnect();
    if(!(await hasNoDef(id))){
        return;
    }
    var column = newData.column;
    var newInformation = newData.newInformation;
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

// word
  static Future<bool> hasWord(int id) async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> result = await db.query(
      'words',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, 
    );
    return result.isNotEmpty;
  }

  static Future<int> addWord(String name, {String? definition, String? parts, String? chinese, String? sentence}) async {

    final db = await getDBConnect();
    
    final Map<String, dynamic> insertingword = {
      'name': name,
      'definition': (definition == null)? '': definition,
      'parts': (parts == null)? '': parts,
      'chinese': (chinese == null)? '': chinese,
      'sentence': (sentence == null)? '': sentence,
    };

    final int newid = await db.insert(
      'words',
      insertingword,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return newid;
  }

  static Future<List<Word>?> getAllWords() async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> wordMaps = await db.query('words');
  
    final List<Word> words = [
      for (final {'id': id as int, 'name': name as String, 'definition': definition as String, 'parts': parts as String, 'chinese': chinese as String, 'sentence': sentence as String}
          in wordMaps)
        Word(id: id, name: name, definition: definition, parts: parts, chinese: chinese, sentence: sentence),
    ];

    for (Word word in words) {
      final List<Map<String, Object?>> labelmap = await db.query(
        'label_lists',
        columns: ['label'], 
        where: 'id = ?',          
        whereArgs: [word.id],
      );
      List<String>? lists;
      if(labelmap.isNotEmpty){
        lists = labelmap.map((map) => map['label'] as String).toList();
      }
      word.set_labels(lists);
    }
    return words;
  }

  static Future<void> deleteWord(int id) async {
    final db = await getDBConnect();
    await db.delete(
      'words',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //return list of id with prefix name
  static Future<List<Word>?> searchWord(String prefix) async {
    final db = await getDBConnect();

    List<Map<String, Object?>> results = await db.query(
      'words',
      where: 'name LIKE ?',
      whereArgs: ['$prefix%'], 
    );

    List<Map<String, Object?>> changeable = List.from(results);
    changeable.sort((a, b){
      final String namea = a['name'] as String;
      final String nameb = b['name'] as String;
      return namea.compareTo(nameb);
    });

    final List<Word> words = [
      for (final {'id': id as int, 'name': name as String, 'definition': definition as String, 'parts': parts as String, 'chinese': chinese as String, 'sentence': sentence as String}
          in changeable)
        Word(id: id, name: name, definition: definition, parts: parts, chinese: chinese, sentence: sentence),
    ];

    for (Word word in words) {
      final List<Map<String, Object?>> labelmap = await db.query(
        'label_lists',
        columns: ['label'], 
        where: 'id = ?',          
        whereArgs: [word.id],
      );
      List<String> lists = labelmap.map((map) => map['label'] as String).toList();
      word.set_labels(lists);
    }
    return words;
  }

  //return list of id that satisfies the requirement
  static Future<List<int>> getWordid(List<WordModifyInformation> conditions) async {
      final db = await getDBConnect();
      List<String> clauseParts = [];
      String whereClause = '';
      List<dynamic> whereArgs = [];
      assert(conditions.isNotEmpty);
      for(var condition in conditions){
        var key = condition.column;
        var value = condition.newInformation;
        clauseParts.add('$key = ?');
        whereArgs.add(value);
      }
      whereClause = clauseParts.join(' AND ');

      final List<Map<String, Object?>> results = await db.query(
        'words',
        columns: ['id'], 
        where: whereClause.isEmpty ? null : whereClause,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
      );
      return [
        for (final {'id': id as int} in results)
        id,
      ];
  }

  //if not find will return null
  static Future<Word?> searchWordDetails(int id) async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> result = await db.query(
        'words',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1, 
      );
    if(result.isNotEmpty){
        var ans = Word(id: result[0]['id'] as int, name: result[0]['name'] as String, definition: result[0]['definition'] as String, parts: result[0]['parts'] as String, chinese: result[0]['chinese'] as String, sentence: result[0]['sentence'] as String);
        final List<Map<String, Object?>> labelmap = await db.query(
          'label_lists',
          columns: ['label'], 
          where: 'id = ?',          
          whereArgs: [ans.id],
        );
        List<String>? lists = null;
        if(labelmap.isNotEmpty){
          lists = labelmap.map((map) => map['label'] as String).toList();
        } 
        ans.set_labels(lists);
        return ans;
    }
    return null;
  }

  static Future<void> updateWord(int id, WordModifyInformation newData) async{
    final db = await getDBConnect();
    if(!(await hasWord(id))){
        return;
    }
    var column = newData.column;
    var newInformation = newData.newInformation;
    assert(column != 'id');
    await db.update(
      'words',
      {
        column: newInformation,
      },
      where:'id = ?',
      whereArgs: [id],
    );
    return;
  }

  static Future<List<Word>?> getWordDetails({required int start, int? end, WordFilterOption? option}) async{
    final db = await getDBConnect();

    if(end != null){
      assert(start <= end);
    }
    
    List<Word>? all_words = await getAllWords(); 
    if(all_words == null){
      return null;
    }
    List<Word>? result = [];
    if(option != null){
      for (final words in all_words){
        String limit = option.limitLabel;
        bool include = option.include;
        final bool haslabel;
        if(words.labels == null){
          haslabel = false;
        }
        else{
          haslabel = words.labels!.contains(limit);
        }
        if((include && haslabel) || !(include || haslabel)){
          result.add(words);
        }
      } 
    }
    else{
      result = all_words;
    }
    
    if(start >= result.length){
      return null;
    }    
    if(end == null || end >= result.length){
      end = result.length;
    }

    return result.sublist(start, end);
  }

//others
  static Future<void> addWordToLabel(int wordId, {String? label, int? labelId}) async{
    final db = await getDBConnect();
    if(!(await hasWord(wordId))){
      return;
    }
    if(labelId == null && label == null){
      return;
    }

    if(labelId != null){
      final List<Map<String, Object?>> result = await db.query(
        'labels',
        where: 'id = ?',
        whereArgs: [labelId],
        limit: 1, 
      );
      label = result[0]['name'] as String;
    }

    await db.insert(
      'label_lists',
      {'id': wordId, 'label': label},
      conflictAlgorithm:  ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeWordFromLabel(int wordId, {String? label, int? labelId}) async{
    final db = await getDBConnect();
    if(!(await hasWord(wordId))){
      return;
    }
    if(labelId == null && label == null){
      return;
    }

    if(labelId != null){
      final List<Map<String, Object?>> result = await db.query(
        'labels',
        where: 'id = ?',
        whereArgs: [labelId],
        limit: 1, 
      );
      label = result[0]['name'] as String;
    }

    await db.delete(
      'label_lists',
      where: 'id = ? AND label = ?',
      whereArgs: [wordId, label],
    );
  }

  static Future<List<Word>?> getWordsByLabel({String? label, int? labelId}) async{
    final db = await getDBConnect();

    if(labelId == null && label == null){
      return null;
    }

    if(labelId != null){
      final List<Map<String, Object?>> result = await db.query(
        'labels',
        where: 'id = ?',
        whereArgs: [labelId],
        limit: 1, 
      );
      label = result[0]['name'] as String;
    }
    if(label == null){
      return null;
    }
    var option = WordFilterOption(limitLabel: label, include: true);
    return await getWordDetails(start: 0, option: option);
  }

  static Future<void> removeAllWordsFromLabel({String? label, int? labelId}) async{
    final db = await getDBConnect();
    List<Word>? all_filtered_words = await getWordsByLabel(label: label, labelId: labelId);
    if(all_filtered_words == null){
      return;
    }
    for(final words in all_filtered_words){
      removeWordFromLabel(words.id, label: label, labelId: labelId);
    }
  }

}