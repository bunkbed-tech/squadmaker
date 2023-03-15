import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/league.dart' show League;
import 'package:squadmaker/models/user.dart' show User;
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

  static String selectRows = """
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
  static String selectStatement = """
      SELECT
        $selectRows,
        ${League.selectRows},
        ${User.selectRows}
      FROM $staticTableName
      INNER JOIN ${League.staticTableName} ON $staticTableName.${League.staticTableName}_id = ${League.staticTableName}.id
      INNER JOIN ${User.staticTableName} ON ${League.staticTableName}.captain_id = ${User.staticTableName}.id
  """;
  static String createStatement = """
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

  Game.fromMap(Map<String, dynamic> map)
      : opponentName = map["${prefix}opponent_name"],
        location = map["${prefix}location"],
        startDatetime = DateTime.parse(map["${prefix}start_datetime"]),
        league = League.fromMap(map),
        yourScore = map["${prefix}your_score"],
        opponentScore = map["${prefix}opponent_score"],
        groupPhoto = map["${prefix}group_photo"],
        super(map["${prefix}id"],
            DateTime.parse(map["${prefix}datetime_created"]));

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

  @override
  String toString() {
    return "Game{id: $id, opponent_name: $opponentName, location: $location, start_datetime: $startDatetime}";
  }

  static Future<List<Game>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery(selectStatement);
    return List.generate(maps.length, (i) => Game.fromMap(maps[i]));
  }
}
