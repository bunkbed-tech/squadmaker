CREATE TABLE trophy (
  id SERIAL PRIMARY KEY,
  datetime_created TIMESTAMPTZ NOT NULL,
  player_id INT NOT NULL REFERENCES player (id),
  trophy_type TEXT NOT NULL,
  date_awarded TEXT NOT NULL
);
