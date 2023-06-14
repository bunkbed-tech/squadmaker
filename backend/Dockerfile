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


FROM base AS builder
RUN cargo build --release --offline


FROM debian:bullseye-slim AS prod
COPY --from=builder /code/target/release/squadmaker-backend /
CMD [ "/squadmaker-backend" ]
