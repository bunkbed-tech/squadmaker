CREATE TABLE league (
  id SERIAL PRIMARY KEY,
  datetime_created TIMESTAMPTZ NOT NULL,
  name TEXT NOT NULL,
  team_name TEXT NOT NULL,
  sport TEXT NOT NULL,
  captain_id INT NOT NULL REFERENCES user (id),
  games_won INT NOT NULL DEFAULT (0),
  games_lost INT NOT NULL DEFAULT (0),
  games_played INT NOT NULL DEFAULT (0)
);
