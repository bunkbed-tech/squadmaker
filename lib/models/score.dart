import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/game.dart' show Game;
import 'package:squadmaker/models/player.dart' show Player;
import 'package:squadmaker/models/gender.dart' show Gender;
import 'package:squadmaker/models/league.dart' show League;
import 'package:squadmaker/models/score_type.dart' show ScoreType;
import 'package:sqflite/sqflite.dart' show Database;

class Score extends Base {
  static const String staticTableName = "score";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  Player player;
  Game game;
  DateTime timestamp;
  ScoreType scoreType;

  static String selectStatement = """
        ${staticTableName}.id AS ${prefix}id,
        ${staticTableName}.datetime_created AS ${prefix}datetime_created,
        ${staticTableName}.player_id AS ${prefix}player_id,
        ${staticTableName}.game_id AS ${prefix}game_id,
        ${staticTableName}.timestamp AS ${prefix}timestamp,
        ${staticTableName}.score_type_id AS ${prefix}score_type_id
        """;

  Score({
    int? id,
    DateTime? datetimeCreated,
    required this.player,
    required this.game,
    required this.timestamp,
    required this.scoreType,
  }) : super(id, datetimeCreated);

  Score.create(Map<String, dynamic> self)
      : player = Player.create(self),
        game = Game.create(self),
        timestamp = DateTime.parse(self["${prefix}timestamp"]),
        scoreType = ScoreType.create(self),
        super(self["${prefix}id"],
            DateTime.parse(self["${prefix}datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "game_id": game.id,
      "timestamp": timestamp.toString(),
      "score_type_id": scoreType.id,
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
        timestamp TEXT NOT NULL,
        score_type_id INTEGER NOT NULL REFERENCES score_type (id)
      );
    """;
  }

  @override
  String toString() {
    return "Score{id: $id, player_name: ${player.name}, game_opponent: ${game.opponentName}, score_value: ${scoreType.value}}";
  }

  static Future<List<Score>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        $selectStatement,
        ${Player.selectStatement},
        ${Game.selectStatement},
        ${Gender.selectStatement},
        ${League.selectStatement},
        ${ScoreType.selectStatement}
      FROM $staticTableName 
      INNER JOIN ${Player.staticTableName} ON $staticTableName.${Player.staticTableName}_id = ${Player.staticTableName}.id
      INNER JOIN ${Game.staticTableName} ON $staticTableName.${Game.staticTableName}_id = ${Game.staticTableName}.id
      INNER JOIN ${Gender.staticTableName} ON ${Player.staticTableName}.${Gender.staticTableName}_id = ${Gender.staticTableName}.id
      INNER JOIN ${League.staticTableName} ON ${Game.staticTableName}.${League.staticTableName}_id = ${League.staticTableName}.id
      INNER JOIN ${ScoreType.staticTableName} ON $staticTableName.${ScoreType.staticTableName}_id = ${ScoreType.staticTableName}.id
      """);
    return List.generate(maps.length, (i) {
      return Score.create(maps[i]);
    });
  }
}
