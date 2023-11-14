rootProject.name = "multiple-docker-build"

include("app")

pluginManagement {
    val githubUser: String by settings.extra.properties
    val githubPackagesReadToken: String by settings.extra.properties

    repositories {
        gradlePluginPortal()
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/bbednarek/*")
            credentials {
                username = githubUser
                password = githubPackagesReadToken
            }
        }
    }
}

dependencyResolutionManagement {
    val githubUser: String by settings.extra.properties
    val githubPackagesReadToken: String by settings.extra.properties

    repositories {
        mavenLocal()
        mavenCentral()
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/bbednarek/*")
            credentials {
                username = githubUser
                password = githubPackagesReadToken
            }
        }
    }
}
