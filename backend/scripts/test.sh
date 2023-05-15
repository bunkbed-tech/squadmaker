#!/usr/bin/env bash

docker-compose up -d db
export $(cat .env | xargs)
sleep 10
cargo test
