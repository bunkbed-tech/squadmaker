CREATE TABLE score_type (
  id SERIAL PRIMARY KEY,
  datetime_created TIMESTAMPTZ NOT NULL,
  value INT NOT NULL,
  sport TEXT NOT NULL,
  name TEXT NOT NULL
);
