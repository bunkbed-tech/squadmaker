INSERT INTO "payment" (player_id, league_id, paid)
VALUES ($1, $2, $3)
RETURNING *
