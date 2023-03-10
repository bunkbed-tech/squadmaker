import 'base.dart' show Base;
import 'gender.dart' show Gender;
import 'package:sqflite/sqflite.dart' show Database;

class Player extends Base {
  static const String _tableName = "player";
  @override
  String get tableName => _tableName;

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

  Player.fromOther(Map<String, dynamic> other)
      : name = other["player__name"],
        gender = Gender.fromOther(other),
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

  Player.fromSelf(Map<String, dynamic> self)
      : name = self["name"],
        gender = Gender.fromOther(self),
        pronouns = self["pronouns"],
        phone = self["phone"],
        email = self["email"],
        birthday = self["birthday"] == "null"
            ? null
            : DateTime.parse(self["birthday"]),
        placeFrom = self["place_from"],
        photo = self["photo"],
        scoreAllTime = self["score_all_time"],
        scoreAvgPerGame = self["score_avg_per_game"],
        gamesAttended = self["games_attended"],
        super(self["id"], DateTime.parse(self["datetime_created"]));

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
      CREATE TABLE $_tableName (
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
        player.*,
        gender.datetime_created AS gender__datetime_created,
        gender.name AS gender__name
      FROM player
      INNER JOIN gender ON player.gender_id = gender.id
      """);

    return List.generate(maps.length, (i) {
      return Player.fromSelf(maps[i]);
    });
  }
}
