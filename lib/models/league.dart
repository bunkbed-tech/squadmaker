import 'package:squadmaker/models/base.dart' show Base;
import 'package:sqflite/sqflite.dart' show Database;

class League extends Base {
  static const String staticTableName = "league";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  String name;
  String teamName;
  String sport; // supposed to be a sport
  String captain; // supposed to be a user
  int? gamesWon;
  int? gamesLost;
  int? gamesPlayed;

  static String selectStatement = """
    ${staticTableName}.id AS ${prefix}id,
    ${staticTableName}.datetime_created AS ${prefix}datetime_created,
    ${staticTableName}.name AS ${prefix}name,
    ${staticTableName}.team_name AS ${prefix}team_name,
    ${staticTableName}.sport AS ${prefix}sport,
    ${staticTableName}.captain AS ${prefix}captain,
    ${staticTableName}.games_won AS ${prefix}games_won,
    ${staticTableName}.games_lost AS ${prefix}games_lost,
    ${staticTableName}.games_played AS ${prefix}games_played
  """;
  static String createStatement = """
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
      : name = other["${prefix}name"],
        teamName = other["${prefix}team_name"],
        sport = other["${prefix}sport"],
        captain = other["${prefix}captain"],
        gamesWon = other["${prefix}games_won"],
        gamesLost = other["${prefix}games_lost"],
        gamesPlayed = other["${prefix}games_played"],
        super(other["league_id"],
            DateTime.parse(other["${prefix}datetime_created"]));

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
