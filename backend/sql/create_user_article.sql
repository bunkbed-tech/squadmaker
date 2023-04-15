INSERT INTO testing.articles(title, content, created_by)
VALUES ($1, $2, $3)
RETURNING id, title, content, created_by;
