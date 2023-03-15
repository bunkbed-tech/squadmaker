import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/league.dart' show League;
import 'package:sqflite/sqflite.dart' show Database;

class Game extends Base {
  static const String staticTableName = "game";
  @override
  String get tableName => staticTableName;

  String opponentName;
  String location;
  DateTime startDatetime;
  League league;
  int? yourScore;
  int? opponentScore;
  String? groupPhoto;

  static const String selectStatement = """
        game.opponent_name AS game__opponent_name,
        game.location AS game__location,
        game.start_datetime AS game__start_datetime,
        game.league_id AS game__league_id,
        game.your_score AS game__your_score,
        game.opponent_score AS game__opponent_score,
        game.group_photo AS game__group_photo,
        game.datetime_created AS game__datetime_created,
        game.id AS game__id
        """;

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

  Game.create(Map<String, dynamic> other)
      : opponentName = other["game__opponent_name"],
        location = other["game__location"],
        startDatetime = DateTime.parse(other["game__start_datetime"]),
        league = League.create(other),
        yourScore = other["game__your_score"],
        opponentScore = other["game__opponent_score"],
        groupPhoto = other["game__group_photo"],
        super(
            other["game__id"], DateTime.parse(other["game__datetime_created"]));

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
      CREATE TABLE $staticTableName (
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
        $selectStatement,
        ${League.selectStatement}
      FROM $staticTableName
      INNER JOIN ${League.staticTableName} ON $staticTableName.${League.staticTableName}_id = ${League.staticTableName}.id
      """);
    return List.generate(maps.length, (i) {
      return Game.create(maps[i]);
    });
  }
}
