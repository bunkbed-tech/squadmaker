import 'package:sqflite/sqflite.dart' show Database, ConflictAlgorithm;

abstract class Base {
  int? id;

  Base(this.id);

  String get tableName;

  Map<String, dynamic> toMap();

  Future<void> insert(Database db) async {
    id = await db.insert(tableName, toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(Database db) async {
    await db.update(tableName, toMap(), where: "id = ?", whereArgs: [id]);
  }

  Future<void> delete(Database db) async {
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}
