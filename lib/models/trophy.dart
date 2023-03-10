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
      DateTime? datetimeCreated,
      required this.player,
      required this.trophyType,
      required this.dateAwarded})
      : super(id, datetimeCreated);

  Trophy.fromSelf(Map<String, dynamic> another)
      : player = Player.fromOther(another),
        trophyType = TrophyType.values.firstWhere(
            (e) => e.toString().split(".").last == another["trophy_type"]),
        dateAwarded = DateTime.parse(another["date_awarded"]),
        super(another["id"], DateTime.parse(another["datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "trophy_type": trophyType.name,
      "date_awarded": dateAwarded.toString(),
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $_tableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
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
        player.games_attended AS player__games_attended,
        gender.datetime_created AS gender__datetime_created,
        gender.name AS gender__name
      FROM trophy 
      INNER JOIN player ON trophy.player_id = player.id
      INNER JOIN gender ON player.gender_id = gender.id
      """);
    return List.generate(maps.length, (i) {
      return Trophy.fromSelf(maps[i]);
    });
  }
}
