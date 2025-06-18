import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Label {
  final int id;
  final String name;
  final int wordnum;

  Label({required this.id, required this.name, required this.wordnum});

  // Convert labels into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'wordnum': wordnum};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Label{id: $id, name: $name, wordnum: $wordnum}';
  }
}

class LabelDB {
  static Database? database;

  static Future<Database> initDatabase() async {
      final database = await openDatabase(
      // Set the path to the database
      join(await getDatabasesPath(), 'label_database.db'),
      // When the database is first created, create a table to store the labels.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE labels(id INTEGER PRIMARY KEY, name TEXT, wordnum INTEGER)',
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

  Future<void> insertLabel(Label label) async {
    // Get a reference to the database.
    final db = await getDBConnect();
    // Insert the Label into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'labels',
      label.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Label>> getLabel() async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> labelMaps = await db.query('labels');

    return [
      for (final {'id': id as int, 'name': name as String, 'wordnum': wordnum as int}
          in labelMaps)
        Label(id: id, name: name, wordnum: wordnum),
    ];
  }

  Future<void> updateLabel(Label label) async {
    final db = await getDBConnect();
    await db.update(
      'labels',
      label.toMap(),
      where: 'id = ?',
      // Pass the label's id as a whereArg to prevent SQL injection.
      whereArgs: [label.id],
    );
  }

  Future<void> deleteLabel(int id) async {
    final db = await getDBConnect();
    await db.delete(
      'labels',
      where: 'id = ?',
      // Pass the label's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<bool> hasLabel(int id) async {
    final db = await getDBConnect();
    final List<Map<String, Object?>> result = await db.query(
      'labels',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, 
    );
    return result.isNotEmpty;
  }
}
