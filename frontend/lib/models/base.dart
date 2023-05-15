import 'package:sqflite/sqflite.dart' show Database, ConflictAlgorithm;

abstract class Base {
  int? id;
  DateTime? datetimeCreated;

  Base(this.id, this.datetimeCreated);

  String get tableName;

  Map<String, dynamic> toMap() {
    datetimeCreated ??= DateTime.now();
    return {
      "datetime_created": datetimeCreated.toString(),
    };
  }

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
