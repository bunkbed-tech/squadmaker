import 'package:squadmaker/models/base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database, Batch;

class Gender extends Base {
  static const String staticTableName = "gender";
  @override
  String get tableName => staticTableName;

  String name;

  static const String selectStatement = """
        gender.id AS gender__id,
        gender.datetime_created AS gender__datetime_created,
        gender.name AS gender__name
        """;

  Gender({
    int? id,
    DateTime? datetimeCreated,
    required this.name,
  }) : super(id, datetimeCreated);

  Gender.create(Map<String, dynamic> other)
      : name = other["gender__name"],
        super(other["gender__id"],
            DateTime.parse(other["gender__datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $staticTableName (
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
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        $selectStatement
      FROM $staticTableName
      """);
    return List.generate(maps.length, (i) {
      return Gender.create(maps[i]);
    });
  }

  static Future<void> initialize(Database db) async {
    Batch batch = db.batch();
    String now = DateTime.now().toString();
    batch.insert(staticTableName, {'name': 'man', 'datetime_created': now});
    batch.insert(staticTableName, {'name': 'woman', 'datetime_created': now});
    batch.insert(staticTableName, {'name': 'other', 'datetime_created': now});
    await batch.commit();
  }
}
