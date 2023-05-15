FROM rust:latest as test
WORKDIR /app
COPY Cargo.toml Cargo.lock ./

# Create fake main.rs file in src and build
RUN mkdir ./src && echo 'fn main() { println!("Dummy!"); }' > ./src/main.rs
RUN cargo build

# Copy rest of code and set command
COPY . .
ENTRYPOINT [ "cargo" ]
CMD [ "test" ]
