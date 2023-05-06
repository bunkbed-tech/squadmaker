-- Add up migration script here
CREATE TABLE league (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  name TEXT NOT NULL,
  team_name TEXT NOT NULL,
  sport sport NOT NULL,
  captain_id INT NOT NULL REFERENCES "user" (id),
  games_won INT NOT NULL DEFAULT (0),
  games_lost INT NOT NULL DEFAULT (0),
  games_played INT NOT NULL DEFAULT (0)
);
