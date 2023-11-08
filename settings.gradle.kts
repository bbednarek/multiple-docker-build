rootProject.name = "multiple-docker-build"

include("app")

pluginManagement {
    val githubUser: String? by settings.extra
    val githubPackagesReadToken: String? by settings.extra

    repositories {
        gradlePluginPortal()
        if (githubUser != null && githubPackagesReadToken != null) {
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
}

dependencyResolutionManagement {
    val githubUser: String? by settings.extra
    val githubPackagesReadToken: String? by settings.extra

    repositories {
        mavenLocal()
        mavenCentral()
        if (githubUser != null && githubPackagesReadToken != null) {
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
}
