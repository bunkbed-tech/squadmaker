import 'base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database, Batch;

class Gender extends Base {
  static const String _tableName = "gender";
  @override
  String get tableName => _tableName;

  String name;

  Gender({
    int? id,
    DateTime? datetimeCreated,
    required this.name,
  }) : super(id, datetimeCreated);

  Gender.fromOther(Map<String, dynamic> other)
      : name = other["gender__name"],
        super(other["player__gender_id"],
            DateTime.parse(other["gender__datetime_created"]));

  Gender.fromSelf(Map<String, dynamic> self)
      : name = self["name"],
        super(self["id"], DateTime.parse(self["datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
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
      return Gender.fromSelf(maps[i]);
    });
  }

  static Future<void> initialize(Database db) async {
    Batch batch = db.batch();
    String now = DateTime.now().toString();
    batch.insert(_tableName, {'name': 'man', 'datetime_created': now});
    batch.insert(_tableName, {'name': 'woman', 'datetime_created': now});
    batch.insert(_tableName, {'name': 'other', 'datetime_created': now});
    await batch.commit();
  }
}
