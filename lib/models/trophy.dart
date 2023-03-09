import 'base.dart' show Base;
import 'gender.dart' show Gender;
import 'player.dart' show Player;
import 'enums.dart' show TrophyType;
import 'package:sqflite/sqflite.dart' show Database;

class Trophy extends Base {
  static const String _tableName = "trophy";
  @override
  String get tableName => _tableName;

  Player player;
  TrophyType trophyType;
  DateTime dateAwarded;

  Trophy(
      {int? id,
      required this.player,
      required this.trophyType,
      required this.dateAwarded})
      : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "trophy_type": trophyType.name,
      "date_awarded": dateAwarded.toString(),
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        player_id INTEGER NOT NULL REFERENCES player (id),
        trophy_type TEXT NOT NULL,
        date_awarded TEXT NOT NULL
      );
    """;
  }

  @override
  String toString() {
    return "Trophy{id: $id, player_name: ${player.name}, trophy_type: ${trophyType.name}, date_awarded: $dateAwarded}";
  }

  static Future<List<Trophy>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        trophy.*,
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
        player.games_attended AS player__games_attended,
        gender.name AS gender__name
      FROM trophy 
      INNER JOIN player ON trophy.player_id = player.id
      INNER JOIN gender ON player.gender_id = gender.id
      """);
    return List.generate(maps.length, (i) {
      return Trophy(
        id: maps[i]["id"],
        player: Player(
          id: maps[i]["player_id"],
          name: maps[i]["player__name"],
          gender: Gender(
              id: maps[i]["player__gender_id"], name: maps[i]["gender__name"]),
          pronouns: maps[i]["player__pronouns"],
          phone: maps[i]["player__phone"],
          email: maps[i]["player__email"],
          birthday: maps[i]["player__birthday"] == "null"
              ? null
              : DateTime.parse(maps[i]["player__birthday"]),
          placeFrom: maps[i]["player__place_from"],
          photo: maps[i]["player__photo"],
          scoreAllTime: maps[i]["player__score_all_time"],
          scoreAvgPerGame: maps[i]["player__score_avg_per_game"],
          gamesAttended: maps[i]["player__games_attended"],
        ),
        trophyType: TrophyType.values.firstWhere(
            (e) => e.toString().split(".").last == maps[i]["trophy_type"]),
        dateAwarded: DateTime.parse(maps[i]["date_awarded"]),
      );
    });
  }
}
