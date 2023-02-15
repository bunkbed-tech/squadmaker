import 'package:sqflite/sqflite.dart' show Database, ConflictAlgorithm;

class League {
  static const String tableName = "league";

  int? id;
  String name;
  String teamName;
  String sport; // supposed to be a sport
  String captain; // supposed to be a user
  int? gamesWon;
  int? gamesLost;
  int? gamesPlayed;

  League({
    this.id,
    required this.name,
    required this.teamName,
    required this.sport,
    required this.captain,
    this.gamesWon,
    this.gamesLost,
    this.gamesPlayed,
  });

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
      CREATE TABLE $tableName (
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

  Future<void> insert(Database db) async {
    await db.insert(tableName, toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<League>> leagues(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);
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

  Future<void> update(Database db) async {
    await db.update(tableName, toMap(), where: "id = ?", whereArgs: [id]);
  }

  Future<void> delete(Database db) async {
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}
