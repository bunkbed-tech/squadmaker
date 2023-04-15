CREATE TABLE $staticTableName (
  id SERIAL PRIMARY KEY,
  datetime_created TIMESTAMPTZ NOT NULL,
  name TEXT NOT NULL,
  gender TEXT NOT NULL,
  pronouns TEXT,
  birthday TEXT,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  place_from TEXT,
  photo TEXT,
  score_all_time INT NOT NULL DEFAULT (0),
  score_avg_per_game REAL,
  games_attended INT NOT NULL DEFAULT (0)
);
