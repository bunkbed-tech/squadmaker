import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/enums.dart' show Sport, ScoreNames;
import 'package:sqflite/sqflite.dart' show Database;

class ScoreType extends Base {
  static const String staticTableName = "score_type";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  int value;
  Sport sport; // currently using an enum
  ScoreNames name; // currently using enum

  static String selectStatement = """
        score_type.id AS ${prefix}id,
        score_type.datetime_created AS ${prefix}datetime_created,
        score_type.name AS ${prefix}name,
        score_type.sport AS ${prefix}sport,
        score_type.value AS ${prefix}value
        """;

  ScoreType({
    int? id,
    DateTime? datetimeCreated,
    required this.value,
    required this.sport,
    required this.name,
  }) : super(id, datetimeCreated);

  ScoreType.create(Map<String, dynamic> other)
      : value = other["${prefix}value"],
        sport = Sport.values.firstWhere(
            (e) => e.toString().split(".").last == other["${prefix}sport"]),
        name = ScoreNames.values.firstWhere(
            (e) => e.toString().split(".").last == other["${prefix}name"]),
        super(other["${prefix}id"],
            DateTime.parse(other["${prefix}datetime_created"]));

  static String createSQLTable() {
    return """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        value INTEGER,
        sport TEXT NOT NULL,
        name TEXT NOT NULL
      );
    """;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "value": value,
      "sport": sport.name,
      "name": name.name,
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  @override
  String toString() {
    return "ScoreType{id: $id, value: $value, sport: ${sport.name}, name: ${name.name}}";
  }

  static Future<List<ScoreType>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        $selectStatement
      FROM $staticTableName
      """);
    return List.generate(maps.length, (i) {
      return ScoreType.create(maps[i]);
    });
  }
}
