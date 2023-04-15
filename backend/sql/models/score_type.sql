CREATE TABLE score_type (
  id SERIAL PRIMARY KEY,
  datetime_created TIMESTAMPTZ NOT NULL,
  value INT NOT NULL,
  sport sport NOT NULL,
  name score_name NOT NULL
);
