INSERT INTO "user" (name, email, username, password_hash, avatar)
VALUES ($1, $2, $3, $4, $5)
RETURNING id, created_at, name, email, username, password_hash, avatar
