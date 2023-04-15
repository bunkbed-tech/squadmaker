CREATE TABLE game (
  id SERIAL PRIMARY KEY,
  datetime_created TIMESTAMPTZ NOT NULL,
  opponent_name TEXT NOT NULL,
  location TEXT NOT NULL,
  start_datetime TIMESTAMPTZ NOT NULL,
  league_id INT NOT NULL REFERENCES league (id),
  your_score INT NOT NULL DEFAULT (0),
  opponent_score INT NOT NULL DEFAULT (0),
  group_photo TEXT
);
