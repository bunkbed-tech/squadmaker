import 'base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database, Batch;

class Gender extends Base {
  static const String _tableName = "gender";
  @override
  String get tableName => _tableName;

  String name;

  Gender({
    int? id,
    required this.name,
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        name TEXT UNIQUE
      );
    """;
  }

  @override
  String toString() {
    return "Gender{id: $id, name: $name}";
  }

  static Future<List<Gender>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Gender(
        id: maps[i]["id"],
        name: maps[i]["name"],
      );
    });
  }

  static Future<void> initialize(Database db) async {
    Batch batch = db.batch();
    batch.insert(_tableName, {'name': 'man'});
    batch.insert(_tableName, {'name': 'woman'});
    batch.insert(_tableName, {'name': 'other'});
    await batch.commit();
  }
}
