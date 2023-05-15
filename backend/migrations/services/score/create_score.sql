INSERT INTO "score" (game_id, player_id, score_type_id)
VALUES ($1, $2, $3)
RETURNING *
