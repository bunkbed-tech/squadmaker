import 'base.dart' show Base;
import 'player.dart' show Player;
import 'gender.dart' show Gender;
import 'game.dart' show Game;
import 'league.dart' show League;
import 'package:sqflite/sqflite.dart' show Database;

class Attendance extends Base {
  static const String _tableName = "attendance";
  @override
  String get tableName => _tableName;

  Player player;
  Game game;
  bool attended;

  Attendance({
    int? id,
    required this.player,
    required this.game,
    required this.attended,
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "game_id": game.id,
      "attended": attended ? 1 : 0,
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
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
        attendance.*,
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
        gender.name AS gender__name,
        game.opponent_name AS game__opponent_name,
        game.location AS game__location,
        game.start_datetime AS game__start_datetime,
        game.league_id AS game__league_id,
        game.your_score AS game__your_score,
        game.opponent_score AS game__opponent_score,
        game.group_photo AS game__group_photo,
        league.name AS league__name,
        league.team_name AS league__team_name,
        league.sport AS league__sport,
        league.captain AS league__captain,
        league.games_won AS league__games_won,
        league.games_lost AS league__games_lost,
        league.games_played AS league__games_played
      FROM attendance
      INNER JOIN player ON attendance.player_id = player.id
      INNER JOIN gender ON player.gender_id = gender.id
      INNER JOIN game ON attendance.game_id = game.id
      INNER JOIN league ON game.league_id = league.id
      """);
    return List.generate(maps.length, (i) {
      return Attendance(
        id: maps[i]["id"],
        player: Player(
          id: maps[i]["player_id"],
          name: maps[i]["player__name"],
          gender: Gender(
              id: maps[i]["player__gender_id"], name: maps[i]["gender__name"]),
          pronouns: maps[i]["player__pronouns"],
          phone: maps[i]["player__phone"],
          email: maps[i]["player__email"],
          birthday: maps[i]["player__birthday"],
          placeFrom: maps[i]["player__place_from"],
          photo: maps[i]["player__photo"],
          scoreAllTime: maps[i]["player__score_all_time"],
          scoreAvgPerGame: maps[i]["player__score_avg_per_game"],
          gamesAttended: maps[i]["player__games_attended"],
        ),
        game: Game(
          id: maps[i]["game_id"],
          opponentName: maps[i]["game__opponent_name"],
          location: maps[i]["game__location"],
          startDatetime: maps[i]["game__start_datetime"],
          league: League(
            id: maps[i]["game__league_id"],
            name: maps[i]["league__name"],
            teamName: maps[i]["league__team_name"],
            sport: maps[i]["league__sport"],
            captain: maps[i]["league__captain"],
            gamesWon: maps[i]["league__games_won"],
            gamesLost: maps[i]["league__games_lost"],
            gamesPlayed: maps[i]["league__games_played"],
          ),
          yourScore: maps[i]["game__your_score"],
          opponentScore: maps[i]["game__opponent_score"],
          groupPhoto: maps[i]["game__group_photo"],
        ),
        attended: maps[i]["attended"] != 0,
      );
    });
  }
}
