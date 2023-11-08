FROM gradle:8.3.0-jdk17-jammy

ARG gh_user
ARG githubPackagesReadToken

WORKDIR app

COPY . .

RUN gradle -PgithubUser=$gh_user -PgithubPackagesReadToken=$githubPackagesReadToken clean build --no-daemon
