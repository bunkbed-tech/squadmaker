import 'base.dart' show Base;
import 'league.dart' show League;
import 'player.dart' show Player;
import 'gender.dart' show Gender;
import 'package:sqflite/sqflite.dart' show Database;

class Payment extends Base {
  static const String staticTableName = "payment";
  @override
  String get tableName => staticTableName;

  Player player;
  League league;
  bool paid;

  static const String selectStatement = """
    payment.id AS payment__id,
    payment.datetime_created AS payment__datetime_created,
    payment.player_id AS payment__player_id,
    payment.league_id AS payment__league_id,
    payment.paid AS payment__paid
  """;

  Payment({
    int? id,
    DateTime? datetimeCreated,
    required this.player,
    required this.league,
    required this.paid,
  }) : super(id, datetimeCreated);

  Payment.create(Map<String, dynamic> self)
      : player = Player.create(self),
        league = League.create(self),
        paid = self["payment__paid"] != 0,
        super(self["payment__id"],
            DateTime.parse(self["payment__datetime_created"]));

  @override
  Map<String, dynamic> toMap() {
    return {
      "player_id": player.id,
      "league_id": league.id,
      "paid": paid ? 1 : 0,
      "datetime_created": super.toMap()["datetime_created"],
    };
  }

  static String createSQLTable() {
    return """
      CREATE TABLE $staticTableName (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        datetime_created TEXT NOT NULL,
        player_id INTEGER NOT NULL REFERENCES player (id),
        league_id INTEGER NOT NULL REFERENCES league (id),
        paid INTEGER
      );
    """;
  }

  @override
  String toString() {
    return "Payment{id: $id, player_name: ${player.name}, league_name: ${league.name}, paid: $paid}";
  }

  static Future<List<Payment>> list(Database db) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
      SELECT
        $selectStatement,
        ${Player.selectStatement},
        ${Gender.selectStatement},
        ${League.selectStatement}
      FROM $staticTableName
      INNER JOIN ${Player.staticTableName} ON $staticTableName.${Player.staticTableName}_id = ${Player.staticTableName}.id
      INNER JOIN ${Gender.staticTableName} ON ${Player.staticTableName}.${Gender.staticTableName}_id = ${Gender.staticTableName}.id
      INNER JOIN ${League.staticTableName} ON $staticTableName.${League.staticTableName}_id = ${League.staticTableName}.id
      """);
    return List.generate(maps.length, (i) {
      return Payment.create(maps[i]);
    });
  }
}
