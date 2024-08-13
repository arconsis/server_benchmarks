# Server Benchmarks

## Intro

This project contains a simple implementation of a Book Store REST API using various frameworks for benchmarking purposes.

The main endpoints of the API consists of:

1) HTTP GET /books?limit=<LIMIT> to fetch a list of books of size <LIMIT>
2) HTTP GET /books/<BOOK_ID> to fetch a specific book by id
3) HTTP POST /books to create a new book entity

Currently you can find the following implementations of the Book Store REST API:

1) [Quarkus](./bookstore-quarkus-reactive)
2) [Quarkus Synchronous](./bookstore-quarkus-sync)
3) [Spring Boot](./bookstore-springboot)
4) [NestJS](./bookstore-nestjs)
5) [Rust](./bookstore-actix)

## Contribute

If you want to contribute to the project please add your implementation following the conventions set by the preceding examples. 
For example if you want to add a new service based on a specific Rust framework like Rocket.rs then create a new folder named
bookstore-rocketrs and put your implementation there. 

To honour consistency please create the following REST APIs:

1) HTTP GET /books?limit=<LIMIT> to fetch a list of books of size <LIMIT>
2) HTTP GET /books/<BOOK_ID> to fetch a specific book by id
3) HTTP POST /books to create a new book entity
4) HTTP DELETE /books/<BOOK_ID> to delete a specific book by id
5) HTTP DELETE /books to delete all the books

You can find a simple Postman collection for calling the API [here](postman)

#### Database

The Book Entities should be stored and fetched from a Postgres Database. For local development you can use the [docker compose](docker-compose.yml) file

#### Local benchmarking

You can locally load and stress test your service using the k6 scripts you will find under [benchmarks](/benchmarks)


## Deployments

### Amazon ECS Fargate

#### Infrastructure as Code

We have used terraform to create the infrastructure for the project and deploy the services to [AWS ECS with Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html). You can find the terraform scripts [here](./terraform).
After you have finished implementing and testing locally the API please proceed with adapting the Terraform Scripts to deploy your solution to our infrastructure.

#### GitHub Actions

Currently we have 5 GitHub Actions defined to create and push the docker images for the services to our ECR registry and an action to plan and apply terraform changes. You can find the actions [here](./.github)
For every new service created we have to define a new action to build and push the docker image to our ECR registry.



### Kubernetes (k8s) deployments

Currently, there exists a limited out-of-the-box support for Kubernetes deployments. 
The GitHub Actions workflows starting with the `k8s-` prefix automatically deploy the services to a configurable k8s instance.

### Publications

1. Spring Boot vs Quarkus Part 1 https://medium.com/arconsis/spring-boot-vs-quarkus-6f44421b7213
2. Spring Boot vs Quarkus Part 2 https://medium.com/arconsis/spring-boot-vs-quarkus-part-2-jvm-runtime-performance-af45d0db116e
3. Intro to AWS and Terraform https://www.youtube.com/watch?v=y4Z0IwoCLQc
