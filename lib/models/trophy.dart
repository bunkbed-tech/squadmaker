import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/player.dart' show Player;
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

  static String selectRows = """
        ${staticTableName}.id AS ${prefix}id,
        ${staticTableName}.datetime_created AS ${prefix}datetime_created,
        ${staticTableName}.player_id AS ${prefix}player_id,
        ${staticTableName}.trophy_type AS ${prefix}trophy_type,
        ${staticTableName}.date_awarded AS ${prefix}date_awarded
  """;
  static String selectStatement = """
      SELECT
        $selectRows,
        ${Player.selectRows}
      FROM $staticTableName 
      INNER JOIN ${Player.staticTableName} ON $staticTableName.${Player.staticTableName}_id = ${Player.staticTableName}.id
  """;
  static String createStatement = """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        player_id INTEGER NOT NULL REFERENCES player (id),
        trophy_type TEXT NOT NULL,
        date_awarded TEXT NOT NULL
      );
  """;

  Trophy(
      {int? id,
      DateTime? datetimeCreated,
      required this.player,
      required this.trophyType,
      required this.dateAwarded})
      : super(id, datetimeCreated);

  Trophy.fromMap(Map<String, dynamic> map)
      : player = Player.fromMap(map),
        trophyType = TrophyType.values.firstWhere(
            (e) => e.toString().split(".").last == map["${prefix}trophy_type"]),
        dateAwarded = DateTime.parse(map["${prefix}date_awarded"]),
        super(map["${prefix}id"],
            DateTime.parse(map["${prefix}datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "trophy_type": trophyType.name,
      "date_awarded": dateAwarded.toString(),
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  @override
  String toString() {
    return "Trophy{id: $id, player_name: ${player.name}, trophy_type: ${trophyType.name}, date_awarded: $dateAwarded}";
  }

  static Future<List<Trophy>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery(selectStatement);
    return List.generate(maps.length, (i) => Trophy.fromMap(maps[i]));
  }
}
