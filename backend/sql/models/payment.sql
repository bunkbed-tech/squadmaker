CREATE TABLE payment (
  id SERIAL PRIMARY KEY,
  datetime_created TIMESTAMPTZ NOT NULL,
  player_id INT NOT NULL REFERENCES player (id),
  league_id INT NOT NULL REFERENCES league (id),
  paid BOOLEAN NOT NULL
);
