#!/usr/bin/env bash

docker-compose up -d db
export $(cat .env | xargs)
sleep 10
cargo test

# Create model tables
# psql -f migrations/models/1-enums.sql postgres
# psql -f migrations/models/2-user.sql postgres
# psql -f migrations/models/3-player.sql postgres
# psql -f migrations/models/4-trophy.sql postgres
# psql -f migrations/models/5-score_type.sql postgres
# psql -f migrations/models/6-league.sql postgres
# psql -f migrations/models/7-game.sql postgres
# psql -f migrations/models/8-payment.sql postgres
# psql -f migrations/models/9-score.sql postgres
# psql -f migrations/models/10-attendance.sql postgres
