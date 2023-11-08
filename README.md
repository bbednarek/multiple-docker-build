# multiple-docker-build
Example of building Dockerfile using multiple files 

## local setup
In order to run the pipeline locally you need to define following properties in `~/.gradle/gradle.properties`.
Tokens can be generated [here](https://github.com/settings/tokens).
```
githubUser=<github_username>
githubPackagesReadToken=<token with: (repo, write:packages) scope>
```
