# Server Benchmarks

## Intro

This project contains a simple implementation of a Book Store REST API using various frameworks for benchmarking purposes.

The main endpoints of the API consists of:

1) HTTP GET /books?limit=<LIMIT> to fetch a list of books of size <LIMIT>
2) HTTP GET /books/<BOOK_ID> to fetch a specific book by id
3) HTTP POST /books to create a new book entity

Currently you can find the following implementations of the Book Store REST API:

1) [Quarkus](./bookstore-quarkus)
2) [Spring Boot](./bookstore-springboot)

## Infrastructure as Code

We have used terraform to create the infrastructure for the project and deploy the services to [AWS ECS with Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html). You can find the terraform scripts [here](./terraform).

## GitHub Actions

Currently we have 3 GitHub Actions defined to create and push the docker images for the services to our ECR repository and an action to plan and apply terraform changes. You can find the actions [here](./.github) 