INSERT INTO "trophy" (player_id, trophy_type)
VALUES ($1, $2)
RETURNING *
