INSERT INTO "attendance" (game_id, teammate_id)
VALUES ($1, $2)
RETURNING *
