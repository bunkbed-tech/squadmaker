import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/enums.dart' show Sport;
import 'package:squadmaker/models/user.dart' show User;
import 'package:sqflite/sqflite.dart' show Database;

class League extends Base {
  static const String staticTableName = "league";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  String name;
  String teamName;
  Sport sport;
  User captain;
  int? gamesWon;
  int? gamesLost;
  int? gamesPlayed;

  static String selectRows = """
    $staticTableName.id AS ${prefix}id,
    $staticTableName.datetime_created AS ${prefix}datetime_created,
    $staticTableName.name AS ${prefix}name,
    $staticTableName.team_name AS ${prefix}team_name,
    $staticTableName.sport AS ${prefix}sport,
    $staticTableName.captain_id AS ${prefix}captain_id,
    $staticTableName.games_won AS ${prefix}games_won,
    $staticTableName.games_lost AS ${prefix}games_lost,
    $staticTableName.games_played AS ${prefix}games_played
  """;
  static String selectStatement = """
      SELECT
        $selectRows,
        ${User.selectRows}
      FROM $staticTableName
      INNER JOIN ${User.staticTableName} ON $staticTableName.captain_id = ${User.staticTableName}.id
  """;
  static String createStatement = """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        name TEXT NOT NULL,
        team_name TEXT NOT NULL,
        sport TEXT NOT NULL,
        captain_id INTEGER NOT NULL REFERENCES user (id),
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

  League.fromMap(Map<String, dynamic> map)
      : name = map["${prefix}name"],
        teamName = map["${prefix}team_name"],
        sport = Sport.values.firstWhere(
            (e) => e.toString().split(".").last == map["${prefix}sport"]),
        captain = User.fromMap(map),
        gamesWon = map["${prefix}games_won"],
        gamesLost = map["${prefix}games_lost"],
        gamesPlayed = map["${prefix}games_played"],
        super(map["${prefix}id"],
            DateTime.parse(map["${prefix}datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "team_name": teamName,
      "sport": sport.name,
      "captain_id": captain.id,
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
    final List<Map<String, dynamic>> maps = await db.rawQuery(selectStatement);
    return List.generate(maps.length, (i) => League.fromMap(maps[i]));
  }
}
