import 'base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database;

class League extends Base {
  static const String _tableName = "league";
  @override
  String get tableName => _tableName;

  String name;
  String teamName;
  String sport; // supposed to be a sport
  String captain; // supposed to be a user
  int? gamesWon;
  int? gamesLost;
  int? gamesPlayed;

  League({
    int? id,
    required this.name,
    required this.teamName,
    required this.sport,
    required this.captain,
    this.gamesWon,
    this.gamesLost,
    this.gamesPlayed,
  }) : super(id);

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
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
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
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return League(
        id: maps[i]["id"],
        name: maps[i]["name"],
        teamName: maps[i]["team_name"],
        sport: maps[i]["sport"],
        captain: maps[i]["captain"],
        gamesWon: maps[i]["games_won"],
        gamesLost: maps[i]["games_lost"],
        gamesPlayed: maps[i]["games_played"],
      );
    });
  }
}
