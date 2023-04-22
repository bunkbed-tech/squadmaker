CREATE TABLE trophy (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  player_id INT NOT NULL REFERENCES player (id),
  trophy_type trophy_type NOT NULL
);
