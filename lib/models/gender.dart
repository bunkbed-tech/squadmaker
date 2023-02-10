import 'package:sqflite/sqflite.dart' show Database, ConflictAlgorithm, Batch;

class Gender {
  static const String tableName = "gender";

  final int id;
  final String name;

  Gender({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        name TEXT UNIQUE
      );
    """;
  }

  @override
  String toString() {
    return "Gender{id: $id, name: $name}";
  }

  Future<void> insert(Database db) async {
    await db.insert(tableName, toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Gender>> genders(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Gender(
        id: maps[i]["id"],
        name: maps[i]["name"],
      );
    });
  }

  static Future<void> initialize(Database db) async {
    Batch batch = db.batch();
    batch.insert(tableName, {'name': 'man'});
    batch.insert(tableName, {'name': 'woman'});
    batch.insert(tableName, {'name': 'other'});
    await batch.commit();
  }

  Future<void> update(Database db) async {
    await db.update(tableName, toMap(), where: "id = ?", whereArgs: [id]);
  }

  Future<void> delete(Database db) async {
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}
