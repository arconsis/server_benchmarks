FROM rust:1.69 as builder
WORKDIR /app/src/bookstore

COPY . .
RUN cargo build --release



FROM debian:buster-slim

RUN apt-get update & apt-get install -y extra-runtime-dependencies & rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/src/bookstore/target/release/bookstore /usr/local/bin/bookstore

CMD ["bookstore"]