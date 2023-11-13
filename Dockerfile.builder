FROM gradle:8.3.0-jdk17-jammy

ARG githubUser
ARG githubPackagesReadToken

WORKDIR app

COPY . .

RUN gradle -PgithubUser=$githubUser -PgithubPackagesReadToken=$githubPackagesReadToken clean build --no-daemon
