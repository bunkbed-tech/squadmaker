FROM rust:latest
COPY Cargo.toml Cargo.lock ./

# Create fake main.rs file in src and build
RUN mkdir ./src && echo 'fn main() { println!("Dummy!"); }' > ./src/main.rs
RUN cargo build
RUN cargo install sqlx-cli --no-default-features --features native-tls,postgres

# Copy rest of code and set command
COPY . .
