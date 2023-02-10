class Game {
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
}
