FROM gradle:8.3.0-jdk17-jammy

WORKDIR app

COPY . .

RUN gradle clean build --no-daemon
