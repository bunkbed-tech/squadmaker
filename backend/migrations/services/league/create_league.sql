INSERT INTO "league" (name, team_name, sport, cost, captain_id)
VALUES ($1, $2, $3, $4, $5)
RETURNING *
