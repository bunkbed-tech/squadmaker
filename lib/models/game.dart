import 'base.dart' show Base;

class Game extends Base {
  static const String _tableName = "game";
  @override
  String get tableName => _tableName;

  Game({
    int? id,
  }) : super(id);

  String createSQLTable() {
    return """
      CREATE TABLE game (
        id SERIAL,
        opponent_name TEXT NOT NULL,
        location TEXT,
        start_datetime TEXT,
        your_score INTEGER NOT NULL DEFAULT (0),
        opponent_score INTEGER NOT NULL DEFAULT (0),
        group_photo TEXT,
        league_id INTEGER NOT NULL REFERENCES league (id)
      );
    """;
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
