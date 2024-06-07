FROM rust:1.72-buster as builder
WORKDIR /usr/src/bookstore
COPY . .
RUN cargo install --path .

FROM debian:bullseye-slim

# For amd64, i.e. x86_64, you can append a flag when invoking the build `... --build-arg "ARCH=x86_64"`
# ARG ARCH=aarch64
ARG ARCH=x86_64
RUN apt-get update && apt-get install -y --no-install-recommends \
                                              ca-certificates \
                                              gcc \
                                              libc6-dev \
                                              libpq-dev \
                                              wget && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/bookstore /usr/local/bin/bookstore
EXPOSE 3000
CMD ["bookstore"]