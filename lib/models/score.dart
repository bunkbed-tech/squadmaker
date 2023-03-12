import 'base.dart' show Base;
import 'game.dart' show Game;
import 'player.dart' show Player;
import 'gender.dart' show Gender;
import 'league.dart' show League;
import 'score_type.dart' show ScoreType;
import 'package:sqflite/sqflite.dart' show Database;

class Score extends Base {
  static const String staticTableName = "score";
  @override
  String get tableName => staticTableName;

  Player player;
  Game game;
  DateTime timestamp;
  ScoreType scoreType;

  static const String selectStatement = """
        score.id AS score__id,
        score.datetime_created AS score__datetime_created,
        score.player_id AS score__player_id,
        score.game_id AS score__game_id,
        score.timestamp AS score__timestamp,
        score.score_type_id AS score__score_type_id
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
        timestamp = DateTime.parse(self["score__timestamp"]),
        scoreType = ScoreType.create(self),
        super(
            self["score__id"], DateTime.parse(self["score__datetime_created"]));

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
