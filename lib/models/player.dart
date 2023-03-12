import 'base.dart' show Base;
import 'gender.dart' show Gender;
import 'package:sqflite/sqflite.dart' show Database;

class Player extends Base {
  static const String staticTableName = "player";
  @override
  String get tableName => staticTableName;

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

  static const String selectStatement = """
        player.id AS player__id,
        player.datetime_created AS player__datetime_created,
        player.name AS player__name,
        player.gender_id AS player__gender_id,
        player.pronouns AS player__pronouns,
        player.phone AS player__phone,
        player.email AS player__email,
        player.birthday AS player__birthday,
        player.place_from AS player__place_from,
        player.photo AS player__photo,
        player.score_all_time AS player__score_all_time,
        player.score_avg_per_game AS player__score_avg_per_game,
        player.games_attended AS player__games_attended
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
      : name = other["player__name"],
        gender = Gender.create(other),
        pronouns = other["player__pronouns"],
        phone = other["player__phone"],
        email = other["player__email"],
        birthday = other["player__birthday"] == "null"
            ? null
            : DateTime.parse(other["player__birthday"]),
        placeFrom = other["player__place_from"],
        photo = other["player__photo"],
        scoreAllTime = other["player__score_all_time"],
        scoreAvgPerGame = other["player__score_avg_per_game"],
        gamesAttended = other["player__games_attended"],
        super(other["player_id"],
            DateTime.parse(other["player__datetime_created"]));

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
