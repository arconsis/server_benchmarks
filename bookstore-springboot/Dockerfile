FROM gradle:7.6.0-jdk17 as builder

WORKDIR /app

COPY settings.gradle.kts .
COPY build.gradle.kts .

COPY ./src src
RUN gradle bootJar


FROM registry.access.redhat.com/ubi9/openjdk-17-runtime

USER 185

EXPOSE 3000

COPY --chown=185 --from=builder app/build/libs/bookstore-springboot-0.0.1-SNAPSHOT.jar /deployments/boot.jar

ENV JAVA_APP_JAR="/deployments/boot.jar"
