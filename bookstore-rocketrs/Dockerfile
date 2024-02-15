# Build stage
FROM rust:1.70-buster as builder
ENV DATABASE_URL=$DATABASE_URL
WORKDIR /app

COPY . . 

RUN cargo build --release

# Production stage
FROM debian:buster-slim
RUN apt-get update && apt-get install -y libssl1.1 && apt clean && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/bin

COPY --from=builder /app/target/release/bookstore-rocketrs .
COPY --from=builder /app/Rocket.toml .

EXPOSE 3000
CMD ["./bookstore-rocketrs"]