FROM rust AS base

RUN apt-get update --yes -qq && \
    apt-get install -qq --no-install-recommends postgresql-client && \
    cargo install sqlx-cli --no-default-features --features native-tls,postgres

WORKDIR /code
EXPOSE 8080

RUN cargo init
COPY Cargo.toml Cargo.lock ./
RUN cargo build
COPY . .

