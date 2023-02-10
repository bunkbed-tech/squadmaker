import 'enums.dart' show Gender;
import 'package:sqflite/sqflite.dart' show Database, ConflictAlgorithm;

class Player {
  static final String tableName = "player";

  final int id;
  final String name;
  final Gender gender;
  final String phone;
  final String email;
  final String pronouns;
  final DateTime birthday;
  final String placeFrom;
  final String photo;
  final int scoreAllTime;
  final double scoreAvgPerGame;
  final int gamesAttended;

  const Player({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    required this.email,
    required this.birthday,
    required this.pronouns,
    required this.placeFrom,
    required this.photo,
    required this.scoreAllTime,
    required this.scoreAvgPerGame,
    required this.gamesAttended,
  });

  set gender(Gender g) {
    gender = g;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "gender": gender,
      "pronouns": pronouns,
      "phone": phone,
      "email": email,
      "birthday": birthday,
      "placeFrom": placeFrom,
      "photo": photo,
      "scoreAllTime": scoreAllTime,
      "scoreAvgPerGame": scoreAvgPerGame,
      "gamesAttended": gamesAttended,     
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE ${tableName} (
        id SERIAL,
        name TEXT NOT NULL,
        gender INTEGER NOT NULL REFERENCES gender (id),
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
    await db.insert(tableName, toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
        placeFrom: maps[i]["placeFrom"],
        photo: maps[i]["photo"],
        scoreAllTime: maps[i]["scoreAllTime"],
        scoreAvgPerGame: maps[i]["scoreAvgPerGame"],
        gamesAttended: maps[i]["gamesAttended"],
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
