FROM gradle:8.3.0-jdk17-jammy

COPY --from=builder /home/gradle/.gradle/caches /home/gradle/.gradle/caches
COPY --from=builder /home/gradle/app /home/gradle/app

WORKDIR /home/gradle/app

ENTRYPOINT ["gradle", "cleanTest", "test", "--no-daemon"]
