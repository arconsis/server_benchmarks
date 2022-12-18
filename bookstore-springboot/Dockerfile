FROM registry.access.redhat.com/ubi9/openjdk-17 as builder

WORKDIR /app

COPY ./gradle/ gradle
COPY  gradlew ./
COPY settings.gradle.kts .
COPY build.gradle.kts .

COPY ./src ./src
RUN ./gradlew bootJar

FROM registry.access.redhat.com/ubi9/openjdk-17-runtime
WORKDIR /opt/app

USER 185

EXPOSE 3000

COPY --from=builder app/build/libs/bookstore-springboot-0.0.1-SNAPSHOT.jar /boot.jar

ENV JAVA_APP_JAR="/boot.jar"
