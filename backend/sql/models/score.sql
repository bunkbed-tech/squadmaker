CREATE TABLE score (
  id SERIAL PRIMARY KEY,
  datetime_created TIMESTAMPTZ NOT NULL,
  player_id INT NOT NULL REFERENCES player (id),
  game_id INT NOT NULL REFERENCES game (id),
  score_type_id INT NOT NULL REFERENCES score_type (id)
);
