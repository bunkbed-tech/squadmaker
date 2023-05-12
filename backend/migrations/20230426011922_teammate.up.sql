-- Add up migration script here
CREATE TABLE teammate (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  player_id INT NOT NULL REFERENCES player (id),
  league_id INT NOT NULL REFERENCES league (id),
  paid BOOLEAN NOT NULL
);
