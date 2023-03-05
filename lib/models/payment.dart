import 'base.dart' show Base;
import 'league.dart' show League;
import 'player.dart' show Player;
import 'gender.dart' show Gender;
import 'package:sqflite/sqflite.dart' show Database;

class Payment extends Base {
  static const String _tableName = "payment";
  @override
  String get tableName => _tableName;

  Player player;
  League league;
  bool paid;

  Payment(
      {int? id, required this.player, required this.league, required this.paid})
      : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "league_id": league.id,
      "paid": paid ? 1 : 0,
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        player_id INTEGER NOT NULL REFERENCES player (id),
        league_id INTEGER NOT NULL REFERENCES league (id),
        paid INTEGER
      );
    """;
  }

  @override
  String toString() {
    return "Payment{id: $id, player_name: ${player.name}, league_name: ${league.name}, paid: $paid}";
  }

  static Future<List<Payment>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        payment.*,
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
        league.name AS league__name,
        league.team_name AS league__team_name,
        league.sport AS league__sport,
        league.captain AS league__captain,
        league.games_won AS league__games_won,
        league.games_lost AS league__games_lost,
        league.games_played AS league__games_played
      FROM payment
      INNER JOIN player ON payment.player_id = player.id
      INNER JOIN gender ON player.gender_id = gender.id
      INNER JOIN league ON payment.league_id = league.id
      """);
    return List.generate(maps.length, (i) {
      return Payment(
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
        league: League(
          id: maps[i]["league_id"],
          name: maps[i]["league__name"],
          teamName: maps[i]["league__team_name"],
          sport: maps[i]["league__sport"],
          captain: maps[i]["league__captain"],
          gamesWon: maps[i]["league__games_won"],
          gamesLost: maps[i]["league__games_lost"],
          gamesPlayed: maps[i]["league__games_played"],
        ),
        paid: maps[i]["paid"] != 0,
      );
    });
  }
}
