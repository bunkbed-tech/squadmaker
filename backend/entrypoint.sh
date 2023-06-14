#!/usr/bin/env bash

sqlx migrate run

export PGPASSWORD="$POSTGRES_PASSWORD"
psql -h db -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f tests/data/dummy.sql

"$@"
