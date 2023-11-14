FROM gradle:8.3.0-jdk17-jammy

COPY --from=builder /home/gradle/.gradle/caches /home/gradle/.gradle/caches
COPY --from=builder /home/gradle/multiple-docker-build /home/gradle/multiple-docker-build

WORKDIR /home/gradle/multiple-docker-build

ENTRYPOINT ["gradle", "cleanTest", "test", "--no-daemon"]
