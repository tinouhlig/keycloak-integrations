# docker pull eclipse-temurin:23.0.1_11-jdk

FROM eclipse-temurin:23.0.1_11-jdk AS app_dev

WORKDIR /app

# install dependencies

RUN apt-get update && apt-get install -y --no-install-recommends \
    maven \
    curl \
    inotify-tools \
;

COPY pom.xml .

RUN mkdir -p /app/maven-local

RUN --mount=type=cache,target=/app/maven-local \
    mvn dependency:go-offline

COPY . ./

RUN --mount=type=cache,target=/app/maven-local \
    mvn clean install -DskipTests

COPY --chmod=775 docker/command /usr/local/bin

CMD ["hot-reload"]



#FROM openjdk:19-jdk-alpine AS app_dev
#
#WORKDIR /app
#
## install dependencies
#
#RUN apk --update upgrade && apk add --no-cache \
#    maven \
#    curl \
#    inotify-tools \
#;
#
#COPY pom.xml .
#
#RUN mkdir -p /app/maven-local
#
#RUN --mount=type=cache,target=/app/maven-local \
#    mvn dependency:go-offline
#
#COPY . ./
#
#RUN --mount=type=cache,target=/app/maven-local \
#    mvn clean install -DskipTests
#
#COPY --chmod=775 docker/command /usr/local/bin
#
#CMD ["hot-reload"]