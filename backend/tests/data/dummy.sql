INSERT INTO "user" (name, email, username, password_hash, avatar)
VALUES (
  'joe',
  'joe@joe.joe',
  'j03',
  'password',
  'joe.joepg'
);
INSERT INTO "player" (name, gender, phone, email, pronouns, birthday, photo, place_from)
VALUES (
  'joe',
  'man',
  '+11234567890',
  'joe@joe.joe',
  'he/him/his',
  '01/01/0001',
  'joe@starbucks.jpg',
  'bethlehem'
);
INSERT INTO "league" (name, team_name, sport, cost, captain_id)
VALUES (
  'the league',
  'joezinhos',
  'kickball',
  420.69,
  1
);
INSERT INTO "game" (opponent_name, game_location, start_datetime, league_id)
VALUES (
  'the bad guys',
  'the ball field',
  '2022-05-06T14:30:00+02:00',
  1
);
INSERT INTO "teammate" (league_id, player_id, paid)
VALUES (1, 1, true);
INSERT INTO "score" (game_id, player_id, score_type_id)
VALUES (1, 1, 1);
INSERT INTO "attendance" (game_id, teammate_id)
VALUES (1, 1);
