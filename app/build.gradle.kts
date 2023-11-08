import org.gradle.api.tasks.testing.logging.TestExceptionFormat.FULL
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.jlleitschuh.gradle.ktlint") version "11.3.1"
    id("maven-publish")
    id("java-library")

    kotlin("jvm") version "1.7.0"
    kotlin("kapt") version "1.7.0"
}

group = "com.bbednarek"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_17

kapt.includeCompileClasspath = false

extra["jackson.version"] = "2.13.4"
extra["kotest.version"] = "5.4.2"
extra["awaitility.version"] = "4.2.0"
extra["restAssured.version"] = "5.2.0"
extra["junit5.version"] = "5.9.0"
extra["faker.version"] = "1.11.0"

dependencies {
    val v = project.extra

    testImplementation("com.fasterxml.jackson.module:jackson-module-kotlin:${v["jackson.version"]}")
    testImplementation("org.junit.jupiter:junit-jupiter:${v["junit5.version"]}")
    testImplementation("io.kotest:kotest-assertions-core:${v["kotest.version"]}")
    testImplementation("io.kotest:kotest-assertions-json:${v["kotest.version"]}")
    testImplementation("org.awaitility:awaitility-kotlin:${v["awaitility.version"]}")
    testImplementation("io.rest-assured:rest-assured:${v["restAssured.version"]}")
    testImplementation("io.rest-assured:kotlin-extensions:${v["restAssured.version"]}")
    testImplementation("io.github.serpro69:kotlin-faker:${v["faker.version"]}")
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs = listOf("-Xjsr305=strict")
        jvmTarget = "17"
    }
}

tasks.withType<Test> {
    val tags: String? by project
    val tagList = tags?.split(",")?.map { it.trim() }
//    println("Running tags: $tags")
    useJUnitPlatform {
        if (tagList != null) {
            includeTags.addAll(tagList)
        }
    }
    testLogging {
        events("passed", "skipped", "failed", "STANDARD_ERROR", "STANDARD_OUT")
        exceptionFormat = FULL
        showCauses = true
        showExceptions = true
        showStackTraces = true
        showStandardStreams = true
    }
}

tasks.register("printGithubPackagesReadToken") {
    doFirst {
        println(project.property("githubPackagesReadToken"))
    }
}

val sourcesJar by tasks.registering(Jar::class) {
    archiveClassifier.set("sources")
    from(sourceSets.main.get().allSource)
}

publishing {
    repositories {
        val githubUser: String by project
        val githubToken: String? by project

        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/bbednarek/${rootProject.name}")
            credentials {
                username = githubUser
                password = githubToken
            }
        }
    }
    publications {
        register("mavenJava", MavenPublication::class) {
            from(components["java"])
            artifact(sourcesJar.get())
        }
    }
}
