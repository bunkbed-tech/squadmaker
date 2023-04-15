SELECT id, title, content, created_by
FROM testing.articles
WHERE created_by = $1
