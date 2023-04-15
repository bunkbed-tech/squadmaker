INSERT INTO testing.users(first_name, last_name)
VALUES ($1, $2)
RETURNING id, first_name, last_name;
