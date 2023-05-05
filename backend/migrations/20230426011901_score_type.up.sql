-- Add up migration script here
CREATE TABLE score_type (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  value INT NOT NULL,
  sport sport NOT NULL,
  name score_name NOT NULL
);

INSERT INTO score_type (value, sport, name)
VALUES
  (1, 'kickball', 'run'),
  (1, 'baseball', 'run'),
  (1, 'softball', 'run');
