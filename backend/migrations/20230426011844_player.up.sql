-- Add up migration script here
CREATE TABLE player (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  name TEXT NOT NULL,
  gender gender NOT NULL,
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
