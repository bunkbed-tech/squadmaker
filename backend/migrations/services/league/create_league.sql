INSERT INTO "league" (name, team_name, sport, captain_id)
VALUES ($1, $2, $3, $4)
RETURNING *
