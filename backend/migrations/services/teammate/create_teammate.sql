INSERT INTO "teammate" (league_id, player_id, paid)
VALUES ($1, $2, $3)
RETURNING *
