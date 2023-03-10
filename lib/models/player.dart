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
      return Player(
        id: maps[i]["id"],
        datetimeCreated: DateTime.parse(maps[i]["datetime_created"]),
        name: maps[i]["name"],
        gender: Gender(
          id: maps[i]["gender_id"],
          datetimeCreated: DateTime.parse(maps[i]["gender__datetime_created"]),
          name: maps[i]["gender__name"],
        ),
        pronouns: maps[i]["pronouns"],
        birthday: maps[i]["birthday"] == "null"
            ? null
            : DateTime.parse(maps[i]["birthday"]),
        phone: maps[i]["phone"],
        email: maps[i]["email"],
        placeFrom: maps[i]["place_from"],
        photo: maps[i]["photo"],
        scoreAllTime: maps[i]["score_all_time"],
        scoreAvgPerGame: maps[i]["score_avg_per_game"],
        gamesAttended: maps[i]["games_attended"],
      );
    });
  }
}
