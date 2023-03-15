import 'package:squadmaker/models/base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database, Batch;

class Gender extends Base {
  static const String staticTableName = "gender";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  String name;

  static String selectStatement = """
        ${staticTableName}.id AS ${prefix}id,
        ${staticTableName}.datetime_created AS ${prefix}datetime_created,
        ${staticTableName}.name AS ${prefix}name
        """;

  Gender({
    int? id,
    DateTime? datetimeCreated,
    required this.name,
  }) : super(id, datetimeCreated);

  Gender.create(Map<String, dynamic> other)
      : name = other["${prefix}name"],
        super(other["${prefix}id"],
            DateTime.parse(other["${prefix}datetime_created"]));

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
