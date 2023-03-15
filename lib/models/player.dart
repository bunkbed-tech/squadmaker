import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/enums.dart' show Gender;
import 'package:sqflite/sqflite.dart' show Database;

class Player extends Base {
  static const String staticTableName = "player";
  @override
  String get tableName => staticTableName;
  static String get prefix => "${staticTableName}__";

  String name;
  String email;
  Gender gender;
  String phone;
  DateTime? birthday;
  String? pronouns;
  String? placeFrom;
  String? photo;
  int? scoreAllTime;
  double? scoreAvgPerGame;
  int? gamesAttended;

  static String selectRows = """
        $staticTableName.id AS ${prefix}id,
        $staticTableName.datetime_created AS ${prefix}datetime_created,
        $staticTableName.name AS ${prefix}name,
        $staticTableName.gender AS ${prefix}gender,
        $staticTableName.pronouns AS ${prefix}pronouns,
        $staticTableName.phone AS ${prefix}phone,
        $staticTableName.email AS ${prefix}email,
        $staticTableName.birthday AS ${prefix}birthday,
        $staticTableName.place_from AS ${prefix}place_from,
        $staticTableName.photo AS ${prefix}photo,
        $staticTableName.score_all_time AS ${prefix}score_all_time,
        $staticTableName.score_avg_per_game AS ${prefix}score_avg_per_game,
        $staticTableName.games_attended AS ${prefix}games_attended
  """;
  static String selectStatement = """
      SELECT
        $selectRows
      FROM $staticTableName
  """;
  static String createStatement = """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        name TEXT NOT NULL,
        gender TEXT NOT NULL,
        pronouns TEXT,
        birthday TEXT,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        place_from TEXT,
        photo TEXT,
        score_all_time INTEGER NOT NULL DEFAULT (0),
        score_avg_per_game REAL,
        games_attended INTEGER NOT NULL DEFAULT (0)
      );
  """;

  Player({
    int? id,
    DateTime? datetimeCreated,
    required this.name,
    required this.email,
    required this.gender,
    required this.phone,
    this.birthday,
    this.pronouns,
    this.placeFrom,
    this.photo,
    this.scoreAllTime,
    this.scoreAvgPerGame,
    this.gamesAttended,
  }) : super(id, datetimeCreated);

  Player.fromMap(Map<String, dynamic> map)
      : name = map["${prefix}name"],
        gender = Gender.values.firstWhere(
            (e) => e.toString().split(".").last == map["${prefix}gender"]),
        pronouns = map["${prefix}pronouns"],
        phone = map["${prefix}phone"],
        email = map["${prefix}email"],
        birthday = map["${prefix}birthday"] == "null"
            ? null
            : DateTime.parse(map["${prefix}birthday"]),
        placeFrom = map["${prefix}place_from"],
        photo = map["${prefix}photo"],
        scoreAllTime = map["${prefix}score_all_time"],
        scoreAvgPerGame = map["${prefix}score_avg_per_game"],
        gamesAttended = map["${prefix}games_attended"],
        super(map["${prefix}id"],
            DateTime.parse(map["${prefix}datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "gender": gender.name,
      "pronouns": pronouns,
      "phone": phone,
      "email": email,
      "birthday": birthday.toString(),
      "place_from": placeFrom,
      "photo": photo,
      "score_all_time": scoreAllTime,
      "score_avg_per_game": scoreAvgPerGame,
      "games_attended": gamesAttended,
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  @override
  String toString() {
    return "Player{id: $id, name: $name, email: $email, gender: ${gender.name}}";
  }

  static Future<List<Player>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery(selectStatement);
    return List.generate(maps.length, (i) => Player.fromMap(maps[i]));
  }
}
