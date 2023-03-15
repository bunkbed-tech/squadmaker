import 'package:squadmaker/models/base.dart' show Base;
import 'package:squadmaker/models/gender.dart' show Gender;
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

  static String selectStatement = """
        player.id AS ${prefix}id,
        player.datetime_created AS ${prefix}datetime_created,
        player.name AS ${prefix}name,
        player.gender_id AS ${prefix}gender_id,
        player.pronouns AS ${prefix}pronouns,
        player.phone AS ${prefix}phone,
        player.email AS ${prefix}email,
        player.birthday AS ${prefix}birthday,
        player.place_from AS ${prefix}place_from,
        player.photo AS ${prefix}photo,
        player.score_all_time AS ${prefix}score_all_time,
        player.score_avg_per_game AS ${prefix}score_avg_per_game,
        player.games_attended AS ${prefix}games_attended
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

  Player.create(Map<String, dynamic> other)
      : name = other["${prefix}name"],
        gender = Gender.create(other),
        pronouns = other["${prefix}pronouns"],
        phone = other["${prefix}phone"],
        email = other["${prefix}email"],
        birthday = other["${prefix}birthday"] == "null"
            ? null
            : DateTime.parse(other["${prefix}birthday"]),
        placeFrom = other["${prefix}place_from"],
        photo = other["${prefix}photo"],
        scoreAllTime = other["${prefix}score_all_time"],
        scoreAvgPerGame = other["${prefix}score_avg_per_game"],
        gamesAttended = other["${prefix}games_attended"],
        super(other["player_id"],
            DateTime.parse(other["${prefix}datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "gender_id": gender.id,
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

  static String createSQLTable() {
    return """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        name TEXT NOT NULL,
        gender_id INTEGER NOT NULL REFERENCES gender (id),
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
  }

  @override
  String toString() {
    return "Player{id: $id, name: $name, email: $email, gender_name: ${gender.name}}";
  }

  static Future<List<Player>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        $selectStatement,
        ${Gender.selectStatement}
      FROM $staticTableName
      INNER JOIN ${Gender.staticTableName} ON $staticTableName.${Gender.staticTableName}_id = ${Gender.staticTableName}.id
      """);
    return List.generate(maps.length, (i) {
      return Player.create(maps[i]);
    });
  }
}
