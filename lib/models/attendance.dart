import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/player.dart' show Player;
import 'package:squadmaker/models/game.dart' show Game;
import 'package:squadmaker/models/league.dart' show League;
import 'package:squadmaker/models/gender.dart' show Gender;
import 'package:sqflite/sqflite.dart' show Database;

class Attendance extends Base {
  static const String staticTableName = "attendance";
  @override
  String get tableName => staticTableName;

  Player player;
  Game game;
  bool attended;

  static const String selectStatement = """
        attendance.player_id AS attendance__player_id,
        attendance.game_id AS attendance__game_id,
        attendance.attended AS attendance__attended,
        attendance.id AS attendance__id,
        attendance.datetime_created AS attendance__datetime_created
        """;

  Attendance({
    int? id,
    DateTime? datetimeCreated,
    required this.player,
    required this.game,
    required this.attended,
  }) : super(id, datetimeCreated);

  Attendance.create(Map<String, dynamic> self)
      : player = Player.create(self),
        game = Game.create(self),
        attended = self["attendance__attended"] != 0,
        super(self["attendance__id"],
            DateTime.parse(self["attendance__datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "game_id": game.id,
      "attended": attended ? 1 : 0,
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        datetime_created TEXT NOT NULL,
        player_id INTEGER NOT NULL REFERENCES player (id),
        game_id INTEGER NOT NULL REFERENCES game (id),
        attended INTEGER NOT NULL
      );
    """;
  }

  @override
  String toString() {
    return "Attendance{id: $id, player_name: ${player.name}, game_opponent: ${game.opponentName}, attended: $attended}";
  }

  static Future<List<Attendance>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        $selectStatement,
        ${Player.selectStatement},
        ${Gender.selectStatement},
        ${Game.selectStatement},
        ${League.selectStatement}
      FROM $staticTableName
      INNER JOIN ${Player.staticTableName} ON $staticTableName.${Player.staticTableName}_id = ${Player.staticTableName}.id
      INNER JOIN ${Gender.staticTableName} ON ${Player.staticTableName}.${Gender.staticTableName}_id = ${Gender.staticTableName}.id
      INNER JOIN ${Game.staticTableName} ON $staticTableName.${Game.staticTableName}_id = ${Game.staticTableName}.id
      INNER JOIN ${League.staticTableName} ON ${Game.staticTableName}.${League.staticTableName}_id = ${League.staticTableName}.id
      """);
    return List.generate(maps.length, (i) {
      return Attendance.create(maps[i]);
    });
  }
}
