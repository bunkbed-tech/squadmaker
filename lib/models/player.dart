import 'gender.dart' show Gender;
import 'package:sqflite/sqflite.dart' show Database, ConflictAlgorithm;

class Player {
  static const String tableName = "player";

  int? id;
  String name;
  String email;
  String gender;
  String phone;
  String? birthday;
  String? pronouns;
  String? placeFrom;
  String? photo;
  int? scoreAllTime;
  double? scoreAvgPerGame;
  int? gamesAttended;

  Player({
    this.id,
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
  });

  // set setGender(Gender g) {
  //   gender = g.toString();
  // }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "gender": gender,
      "pronouns": pronouns,
      "phone": phone,
      "email": email,
      "birthday": birthday,
      "place_from": placeFrom,
      "photo": photo,
      "score_all_time": scoreAllTime,
      "score_avg_per_game": scoreAvgPerGame,
      "games_attended": gamesAttended,
    };
  }

  // gender INTEGER NOT NULL REFERENCES gender (id),
  static String createSQLTable() {
    return """
      CREATE TABLE $tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        name TEXT NOT NULL,
        gender TEXT,
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
    return "Player{id: $id, name: $name, email: $email}";
  }

  Future<void> insert(Database db) async {
    await db.insert(tableName, toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Player>> players(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Player(
        id: maps[i]["id"],
        name: maps[i]["name"],
        gender: maps[i]["gender"],
        pronouns: maps[i]["pronouns"],
        birthday: maps[i]["birthday"],
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

  Future<void> update(Database db) async {
    await db.update(tableName, toMap(), where: "id = ?", whereArgs: [id]);
  }

  Future<void> delete(Database db) async {
    await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}
