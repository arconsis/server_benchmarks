FROM registry.access.redhat.com/ubi9/openjdk-17 as builder

WORKDIR /app

COPY ./gradle/ gradle
COPY gradlew .
COPY gradle.properties .
COPY settings.gradle.kts .
COPY build.gradle.kts .

COPY ./src src

RUN ./gradlew -b /app/build.gradle.kts build


FROM registry.access.redhat.com/ubi9/openjdk-17-runtime

ENV LANGUAGE='en_US:en'

# We make four distinct layers so if there are application changes the library layers can be re-used
COPY --chown=185 --from=builder app/build/quarkus-app/lib/ /deployments/lib/
COPY --chown=185 --from=builder app/build/quarkus-app/*.jar /deployments/
COPY --chown=185 --from=builder app/build/quarkus-app/app/ /deployments/app/
COPY --chown=185 --from=builder app/build/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 3000
USER 185
ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"
