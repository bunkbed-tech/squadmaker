import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/player.dart' show Player;
import 'package:squadmaker/models/gender.dart' show Gender;
import 'package:squadmaker/models/enums.dart' show TrophyType;
import 'package:sqflite/sqflite.dart' show Database;

class Trophy extends Base {
  static const String staticTableName = "trophy";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  Player player;
  TrophyType trophyType;
  DateTime dateAwarded;

  static String selectStatement = """
        trophy.id AS ${prefix}id,
        trophy.datetime_created AS ${prefix}datetime_created,
        trophy.player_id AS ${prefix}player_id,
        trophy.trophy_type AS ${prefix}trophy_type,
        trophy.date_awarded AS ${prefix}date_awarded
        """;

  Trophy(
      {int? id,
      DateTime? datetimeCreated,
      required this.player,
      required this.trophyType,
      required this.dateAwarded})
      : super(id, datetimeCreated);

  Trophy.create(Map<String, dynamic> another)
      : player = Player.create(another),
        trophyType = TrophyType.values.firstWhere((e) =>
            e.toString().split(".").last == another["${prefix}trophy_type"]),
        dateAwarded = DateTime.parse(another["${prefix}date_awarded"]),
        super(another["${prefix}id"],
            DateTime.parse(another["${prefix}datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "trophy_type": trophyType.name,
      "date_awarded": dateAwarded.toString(),
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        player_id INTEGER NOT NULL REFERENCES player (id),
        trophy_type TEXT NOT NULL,
        date_awarded TEXT NOT NULL
      );
    """;
  }

  @override
  String toString() {
    return "Trophy{id: $id, player_name: ${player.name}, trophy_type: ${trophyType.name}, date_awarded: $dateAwarded}";
  }

  static Future<List<Trophy>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        $selectStatement,
        ${Player.selectStatement},
        ${Gender.selectStatement}
      FROM $staticTableName 
      INNER JOIN ${Player.staticTableName} ON $staticTableName .${Player.staticTableName}_id = ${Player.staticTableName}.id
      INNER JOIN ${Gender.staticTableName} ON ${Player.staticTableName}.${Gender.staticTableName}_id = ${Gender.staticTableName}.id
      """);
    return List.generate(maps.length, (i) {
      return Trophy.create(maps[i]);
    });
  }
}
