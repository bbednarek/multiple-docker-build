# multiple-docker-build
Example of building Dockerfile using multiple files 

## local setup
In order to run the pipeline locally you need to define following properties in `~/.gradle/gradle.properties`.
GitHub's tokens can be generated [here](https://github.com/settings/tokens).
Docker's tokens can be generated [here](https://hub.docker.com/settings/security).
```
githubUser=<github_username>
githubToken=<token with: (repo, write:packages) scope>
githubPackagesReadToken=<token with: (repo, read:packages) scope>

dockerUsername=<docker_username>>
dockerToken=<docker token with: (Read, Write, Delete) scope>
```
