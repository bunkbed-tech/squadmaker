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

  Game.fromOther(Map<String, dynamic> other)
      : opponentName = other["game__opponent_name"],
        location = other["game__location"],
        startDatetime = DateTime.parse(other["game__start_datetime"]),
        league = League.fromOther(other),
        yourScore = other["game__your_score"],
        opponentScore = other["game__opponent_score"],
        groupPhoto = other["game__group_photo"],
        super(
            other["game_id"], DateTime.parse(other["game__datetime_created"]));

  Game.fromSelf(Map<String, dynamic> self)
      : opponentName = self["opponent_name"],
        location = self["location"],
        startDatetime = DateTime.parse(self["start_datetime"]),
        league = League.fromOther(self),
        yourScore = self["your_score"],
        opponentScore = self["opponent_score"],
        groupPhoto = self["group_photo"],
        super(self["id"], DateTime.parse(self["datetime_created"]));

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
      return Game.fromSelf(maps[i]);
    });
  }
}
