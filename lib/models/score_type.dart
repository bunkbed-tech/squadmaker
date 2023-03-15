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

  static String selectRows = """
        $staticTableName.id AS ${prefix}id,
        $staticTableName.datetime_created AS ${prefix}datetime_created,
        $staticTableName.name AS ${prefix}name,
        $staticTableName.sport AS ${prefix}sport,
        $staticTableName.value AS ${prefix}value
  """;
  static String selectStatement = """
      SELECT
        $selectRows
      FROM $staticTableName
  """;
  static String createStatement = """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        value INTEGER,
        sport TEXT NOT NULL,
        name TEXT NOT NULL
      );
  """;

  ScoreType({
    int? id,
    DateTime? datetimeCreated,
    required this.value,
    required this.sport,
    required this.name,
  }) : super(id, datetimeCreated);

  ScoreType.fromMap(Map<String, dynamic> map)
      : value = map["${prefix}value"],
        sport = Sport.values.firstWhere(
            (e) => e.toString().split(".").last == map["${prefix}sport"]),
        name = ScoreNames.values.firstWhere(
            (e) => e.toString().split(".").last == map["${prefix}name"]),
        super(map["${prefix}id"],
            DateTime.parse(map["${prefix}datetime_created"]));

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
    final List<Map<String, dynamic>> maps = await db.rawQuery(selectStatement);
    return List.generate(maps.length, (i) => ScoreType.fromMap(maps[i]));
  }
}
