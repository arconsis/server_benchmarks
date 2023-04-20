# bookstore-actix Project

This project uses Actix and Sea-Orm, the Mega-Ultra-Supersonic Subatomic Rust Frameworks.

If you want to learn more about Rust and the used frameworks, please visit their websites: https://www.rust-lang.org & https://actix.rs &  https://www.sea-ql.org.

## Running the application in dev mode

You can run your application in dev mode:
```shell script
cargo run
```

You can access the application api under the context: http://localhost:3000/actix

There is a health check via: http://localhost:3000/actix/a/health

## Packaging and running the application

The application can be packaged using:
```shell script
cargo build
```
It produces the `bookstore` file in the `target/debug/` directory.

The application is now runnable using the `bookstore` executable.

If you want to build a _release_, execute the following command:
```shell script
cargo build --release
```
