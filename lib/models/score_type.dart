import 'base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database;
import 'enums.dart' show Sport, ScoreNames;

class ScoreType extends Base {
  static const String _tableName = "score_type";
  @override
  String get tableName => _tableName;

  int value;
  Sport sport; // currently using an enum
  ScoreNames name; // currently using enum

  ScoreType({
    int? id,
    DateTime? datetimeCreated,
    required this.value,
    required this.sport,
    required this.name,
  }) : super(id, datetimeCreated);

  ScoreType.fromOther(Map<String, dynamic> other)
      : value = other["score_type__value"],
        sport = Sport.values.firstWhere(
            (e) => e.toString().split(".").last == other["score_type__sport"]),
        name = ScoreNames.values.firstWhere(
            (e) => e.toString().split(".").last == other["score_type__name"]),
        super(other["score_type_id"],
            DateTime.parse(other["score_type__datetime_created"]));

  ScoreType.fromSelf(Map<String, dynamic> self)
      : value = self["value"],
        sport = Sport.values
            .firstWhere((e) => e.toString().split(".").last == self["sport"]),
        name = ScoreNames.values
            .firstWhere((e) => e.toString().split(".").last == self["name"]),
        super(self["id"], DateTime.parse(self["datetime_created"]));

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
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
        score_type.*
      FROM score_type
      """);
    return List.generate(maps.length, (i) {
      return ScoreType.fromSelf(maps[i]);
    });
  }
}
