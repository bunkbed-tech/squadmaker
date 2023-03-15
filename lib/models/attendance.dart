import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/player.dart' show Player;
import 'package:squadmaker/models/game.dart' show Game;
import 'package:squadmaker/models/league.dart' show League;
import 'package:squadmaker/models/user.dart' show User;
import 'package:sqflite/sqflite.dart' show Database;

class Attendance extends Base {
  static const String staticTableName = "attendance";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  Player player;
  Game game;
  bool attended;

  static String selectRows = """
        ${staticTableName}.player_id AS ${prefix}player_id,
        ${staticTableName}.game_id AS ${prefix}game_id,
        ${staticTableName}.attended AS ${prefix}attended,
        ${staticTableName}.id AS ${prefix}id,
        ${staticTableName}.datetime_created AS ${prefix}datetime_created
  """;
  static String selectStatement = """
      SELECT
        $selectRows,
        ${Player.selectRows},
        ${Game.selectRows},
        ${League.selectRows},
        ${User.selectRows}
      FROM $staticTableName
      INNER JOIN ${Player.staticTableName} ON $staticTableName.${Player.staticTableName}_id = ${Player.staticTableName}.id
      INNER JOIN ${Game.staticTableName} ON $staticTableName.${Game.staticTableName}_id = ${Game.staticTableName}.id
      INNER JOIN ${League.staticTableName} ON ${Game.staticTableName}.${League.staticTableName}_id = ${League.staticTableName}.id
      INNER JOIN ${User.staticTableName} ON ${League.staticTableName}.captain_id = ${User.staticTableName}.id
  """;
  static String createStatement = """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        datetime_created TEXT NOT NULL,
        player_id INTEGER NOT NULL REFERENCES player (id),
        game_id INTEGER NOT NULL REFERENCES game (id),
        attended INTEGER NOT NULL
      );
  """;

  Attendance({
    int? id,
    DateTime? datetimeCreated,
    required this.player,
    required this.game,
    required this.attended,
  }) : super(id, datetimeCreated);

  Attendance.fromMap(Map<String, dynamic> map)
      : player = Player.fromMap(map),
        game = Game.fromMap(map),
        attended = map["${prefix}attended"] != 0,
        super(map["${prefix}id"],
            DateTime.parse(map["${prefix}datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "game_id": game.id,
      "attended": attended ? 1 : 0,
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  @override
  String toString() {
    return "Attendance{id: $id, player_name: ${player.name}, game_opponent: ${game.opponentName}, attended: $attended}";
  }

  static Future<List<Attendance>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery(selectStatement);
    return List.generate(maps.length, (i) => Attendance.fromMap(maps[i]));
  }
}
