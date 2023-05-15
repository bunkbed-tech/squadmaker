-- Add up migration script here
CREATE TYPE sport AS ENUM ('kickball', 'baseball', 'softball');
CREATE TYPE score_name AS ENUM ('run');
CREATE TYPE trophy_type AS ENUM ('perfect_attendance', 'high_score_game', 'high_score_league', 'hat_trick');
CREATE TYPE gender AS ENUM ('man', 'woman', 'other');
