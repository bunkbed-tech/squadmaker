import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/league.dart' show League;
import 'package:sqflite/sqflite.dart' show Database;

class Game extends Base {
  static const String staticTableName = "game";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  String opponentName;
  String location;
  DateTime startDatetime;
  League league;
  int? yourScore;
  int? opponentScore;
  String? groupPhoto;

  static String selectStatement = """
        ${staticTableName}.opponent_name AS ${prefix}opponent_name,
        ${staticTableName}.location AS ${prefix}location,
        ${staticTableName}.start_datetime AS ${prefix}start_datetime,
        ${staticTableName}.league_id AS ${prefix}league_id,
        ${staticTableName}.your_score AS ${prefix}your_score,
        ${staticTableName}.opponent_score AS ${prefix}opponent_score,
        ${staticTableName}.group_photo AS ${prefix}group_photo,
        ${staticTableName}.datetime_created AS ${prefix}datetime_created,
        ${staticTableName}.id AS ${prefix}id
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
      : opponentName = other["${prefix}opponent_name"],
        location = other["${prefix}location"],
        startDatetime = DateTime.parse(other["${prefix}start_datetime"]),
        league = League.create(other),
        yourScore = other["${prefix}your_score"],
        opponentScore = other["${prefix}opponent_score"],
        groupPhoto = other["${prefix}group_photo"],
        super(other["${prefix}id"],
            DateTime.parse(other["${prefix}datetime_created"]));

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
