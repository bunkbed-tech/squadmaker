import 'base.dart' show Base;
import 'game.dart' show Game;
import 'gender.dart' show Gender;
import 'league.dart' show League;
import 'player.dart' show Player;
import 'score_type.dart' show ScoreType;
import 'enums.dart' show Sport, ScoreNames;
import 'package:sqflite/sqflite.dart' show Database;

class Score extends Base {
  static const String _tableName = "score";
  @override
  String get tableName => _tableName;

  Player player;
  Game game;
  DateTime timestamp;
  ScoreType scoreType;

  Score({
    int? id,
    DateTime? datetimeCreated,
    required this.player,
    required this.game,
    required this.timestamp,
    required this.scoreType,
  }) : super(id, datetimeCreated);

  Score.fromSelf(Map<String, dynamic> self)
      : player = Player.fromOther(self),
        game = Game.fromOther(self),
        timestamp = DateTime.parse(self["timestamp"]),
        scoreType = ScoreType.fromOther(self),
        super(self["id"], DateTime.parse(self["datetime_created"]));

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
      CREATE TABLE $_tableName (
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
        score.*,
        player.datetime_created AS player__datetime_created,
        player.name AS player__name,
        player.gender_id AS player__gender_id,
        player.pronouns AS player__pronouns,
        player.phone AS player__phone,
        player.email AS player__email,
        player.birthday AS player__birthday,
        player.place_from AS player__place_from,
        player.photo AS player__photo,
        player.score_all_time AS player__score_all_time,
        player.score_avg_per_game AS player__score_avg_per_game,
        player.games_attended AS player__games_attended,
        game.datetime_created AS game__datetime_created,
        game.opponent_name AS game__opponent_name,
        game.location AS game__location,
        game.start_datetime AS game__start_datetime,
        game.league_id AS league_id,
        game.your_score AS game__your_score,
        game.opponent_score AS game__opponent_score,
        game.group_photo AS game__group_photo,
        gender.datetime_created AS gender__datetime_created,
        gender.name AS gender__name,
        league.datetime_created AS league__datetime_created,
        league.name AS league__name,
        league.team_name AS league__team_name,
        league.sport AS league__sport,
        league.captain AS league__captain,
        league.games_won AS league__games_won,
        league.games_lost AS league__games_lost,
        league.games_played AS league__games_played,
        score_type.datetime_created AS score_type__datetime_created,
        score_type.value AS score_type__value,
        score_type.sport AS score_type__sport,
        score_type.name AS score_type__name
      FROM score 
      INNER JOIN player ON score.player_id = player.id
      INNER JOIN game ON score.game_id = game.id
      INNER JOIN gender ON player.gender_id = gender.id
      INNER JOIN league ON game.league_id = league.id
      INNER JOIN score_type ON score.score_type_id = score_type.id
      """);
    return List.generate(maps.length, (i) {
      return Score.fromSelf(maps[i]);
    });
  }
}
