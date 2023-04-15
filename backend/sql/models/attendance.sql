CREATE TABLE attendance (
  id SERIAL PRIMARY KEY,
  datetime_created TIMESTAMPTZ NOT NULL,
  player_id INT NOT NULL REFERENCES player (id),
  game_id INT NOT NULL REFERENCES game (id),
  attended INT NOT NULL
);
