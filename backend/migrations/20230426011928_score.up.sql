-- Add up migration script here
CREATE TABLE score (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  player_id INT NOT NULL REFERENCES player (id),
  game_id INT NOT NULL REFERENCES game (id),
  score_type_id INT NOT NULL REFERENCES score_type (id)
);
