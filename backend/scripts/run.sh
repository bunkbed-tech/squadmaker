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
psql -f sql/models/enums.sql postgres
psql -f sql/models/user.sql postgres
psql -f sql/models/player.sql postgres
psql -f sql/models/trophy.sql postgres
psql -f sql/models/score_type.sql postgres
psql -f sql/models/league.sql postgres
psql -f sql/models/game.sql postgres
psql -f sql/models/payment.sql postgres
psql -f sql/models/score.sql postgres
psql -f sql/models/attendance.sql postgres

# Start app server
cargo run

# Stop database server
pg_ctl -D "$PGDATA" stop

# Delete data
rm -rf "$PGDATA"
