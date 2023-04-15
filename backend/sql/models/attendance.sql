CREATE TABLE attendance (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  player_id INT NOT NULL REFERENCES player (id),
  game_id INT NOT NULL REFERENCES game (id),
  attended INT NOT NULL
);
