#!/usr/bin/env bash
PGDATA="$(pwd)/data/postgresql"
PGLOGS="$(pwd)/logs/postgresql"

# Create data and logging folders
mkdir -p "$PGDATA"
mkdir -p "$PGLOGS"

# Initialize database
[[ -d "$PGDATA" && ! $(ls -A "$PGDATA") ]] && initdb -D "$PGDATA"

# Start database server
pg_ctl -D "$PGDATA" -l "$PGLOGS/$(date +"%Y%m%d")" start

# Create model tables
psql -f migrations/models/enums.sql postgres
psql -f migrations/models/user.sql postgres
psql -f migrations/models/player.sql postgres
psql -f migrations/models/trophy.sql postgres
psql -f migrations/models/score_type.sql postgres
psql -f migrations/models/league.sql postgres
psql -f migrations/models/game.sql postgres
psql -f migrations/models/payment.sql postgres
psql -f migrations/models/score.sql postgres
psql -f migrations/models/attendance.sql postgres

# Start app server
cargo test

# Stop database server
pg_ctl -D "$PGDATA" stop

# Delete data
rm -rf "$PGDATA"
