INSERT INTO "game" (opponent_name, game_location, start_datetime, league_id)
VALUES ($1, $2, $3, $4)
RETURNING *
