INSERT INTO "player" (name, gender, phone, email, pronouns, birthday, place_from, photo)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *
