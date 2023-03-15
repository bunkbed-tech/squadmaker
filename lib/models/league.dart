import 'package:squadmaker/models/base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database;

class League extends Base {
  static const String staticTableName = "league";
  @override
  String get tableName => staticTableName;

  String name;
  String teamName;
  String sport; // supposed to be a sport
  String captain; // supposed to be a user
  int? gamesWon;
  int? gamesLost;
  int? gamesPlayed;

  static const String selectStatement = """
    league.id AS league__id,
    league.datetime_created AS league__datetime_created,
    league.name AS league__name,
    league.team_name AS league__team_name,
    league.sport AS league__sport,
    league.captain AS league__captain,
    league.games_won AS league__games_won,
    league.games_lost AS league__games_lost,
    league.games_played AS league__games_played
  """;

  League({
    int? id,
    DateTime? datetimeCreated,
    required this.name,
    required this.teamName,
    required this.sport,
    required this.captain,
    this.gamesWon,
    this.gamesLost,
    this.gamesPlayed,
  }) : super(id, datetimeCreated);

  League.create(Map<String, dynamic> other)
      : name = other["league__name"],
        teamName = other["league__team_name"],
        sport = other["league__sport"],
        captain = other["league__captain"],
        gamesWon = other["league__games_won"],
        gamesLost = other["league__games_lost"],
        gamesPlayed = other["league__games_played"],
        super(other["league_id"],
            DateTime.parse(other["league__datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "team_name": teamName,
      "sport": sport,
      "captain": captain,
      "games_won": gamesWon,
      "games_lost": gamesLost,
      "games_played": gamesPlayed,
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        name TEXT NOT NULL,
        team_name TEXT NOT NULL,
        sport TEXT NOT NULL,
        captain TEXT NOT NULL,
        games_won INTEGER NOT NULL DEFAULT (0),
        games_lost INTEGER NOT NULL DEFAULT (0),
        games_played INTEGER NOT NULL DEFAULT (0)
      );
    """;
  }

  @override
  String toString() {
    return "League{id: $id, name: $name, team_name: $teamName, sport: $sport}";
  }

  static Future<List<League>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        $selectStatement
      FROM $staticTableName
      """);
    return List.generate(maps.length, (i) {
      return League.create(maps[i]);
    });
  }
}
