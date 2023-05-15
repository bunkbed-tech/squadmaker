-- Add up migration script here
CREATE TABLE attendance (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  game_id INT NOT NULL REFERENCES game (id),
  teammate_id INT NOT NULL REFERENCES teammate (id)
  );
