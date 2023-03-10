import 'base.dart' show Base;
import 'league.dart' show League;
import 'package:sqflite/sqflite.dart' show Database;

class Game extends Base {
  static const String _tableName = "game";
  @override
  String get tableName => _tableName;

  String opponentName;
  String location;
  DateTime startDatetime;
  League league;
  int? yourScore;
  int? opponentScore;
  String? groupPhoto;

  Game({
    int? id,
    DateTime? datetimeCreated,
    required this.opponentName,
    required this.location,
    required this.startDatetime,
    required this.league,
    this.yourScore,
    this.opponentScore,
    this.groupPhoto,
  }) : super(id, datetimeCreated);

  @override
  Map<String, dynamic> toMap() {
    return {
      "opponent_name": opponentName,
      "location": location,
      "start_datetime": startDatetime.toString(),
      "league_id": league.id,
      "your_score": yourScore,
      "opponent_score": opponentScore,
      "group_photo": groupPhoto,
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        opponent_name TEXT NOT NULL,
        location TEXT NOT NULL,
        start_datetime TEXT NOT NULL,
        league_id INTEGER NOT NULL REFERENCES league (id),
        your_score INTEGER NOT NULL DEFAULT (0),
        opponent_score INTEGER NOT NULL DEFAULT (0),
        group_photo TEXT
      );
    """;
  }

  @override
  String toString() {
    return "Game{id: $id, opponent_name: $opponentName, location: $location, start_datetime: $startDatetime}";
  }

  static Future<List<Game>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        game.*,
        league.datetime_created AS league__datetime_created,
        league.name AS league__name,
        league.team_name AS league__team_name,
        league.sport AS league__sport,
        league.captain AS league__captain,
        league.games_won AS league__games_won,
        league.games_lost AS league__games_lost,
        league.games_played AS league__games_played
      FROM game
      INNER JOIN league ON game.league_id = league.id
      """);

    return List.generate(maps.length, (i) {
      return Game(
        id: maps[i]["id"],
        datetimeCreated: DateTime.parse(maps[i]["datetime_created"]),
        opponentName: maps[i]["opponent_name"],
        location: maps[i]["location"],
        startDatetime: DateTime.parse(maps[i]["start_datetime"]),
        league: League(
          id: maps[i]["league_id"],
          datetimeCreated: DateTime.parse(maps[i]["league__datetime_created"]),
          name: maps[i]["league__name"],
          teamName: maps[i]["league__team_name"],
          sport: maps[i]["league__sport"],
          captain: maps[i]["league__captain"],
          gamesWon: maps[i]["league__games_won"],
          gamesLost: maps[i]["league__games_lost"],
          gamesPlayed: maps[i]["league__games_played"],
        ),
        yourScore: maps[i]["your_score"],
        opponentScore: maps[i]["opponent_score"],
        groupPhoto: maps[i]["group_photo"],
      );
    });
  }
}
