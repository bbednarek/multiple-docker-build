FROM gradle:8.3.0-jdk17-jammy

ARG githubUser
ARG githubPackagesReadToken

WORKDIR multiple-docker-build

COPY .. .

RUN gradle -PgithubUser=$githubUser -PgithubPackagesReadToken=$githubPackagesReadToken clean build --no-daemon
