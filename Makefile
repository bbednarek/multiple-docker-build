IMAGE_NAME=multiple-docker-build
PLATFORMS=`([ "$(uname -m)" = "x86_64" ] && echo "linux/amd64") || echo "linux/arm64"`
GH_USER=`git config user.name`
GH_PACKAGES_READ_TOKEN=`./gradlew printGithubPackagesReadToken -q`
DOCKER_USERNAME=`./gradlew printDockerUsername -q`
DOCKER_TOKEN=`./gradlew printDockerToken -q`
VERSION=

all: clean test

clean:
	./gradlew clean
	cd app2; ./gradlew clean
	docker image rm -f ${IMAGE_NAME}
	rm -rf builder-image

build-app:
	./gradlew build --no-daemon
	cd app2; ./gradlew build --no-daemon

build-docker-jib:
	if [ -z "$GH_PACKAGES_READ_TOKEN" ]; then echo "ERROR: GH_PACKAGES_READ_TOKEN env variable is not defined. Please check project README."; exit 1; fi
	if [ -z "$DOCKER_USERNAME" ]; then echo "ERROR: DOCKER_USERNAME env variable is not defined. Please check project README."; exit 1; fi
	if [ -z "$DOCKER_TOKEN" ]; then echo "ERROR: DOCKER_TOKEN env variable is not defined. Please check project README."; exit 1; fi
	./gradlew :app:jib --no-daemon -PgithubUser=${GH_USER} -PgithubPackagesReadToken=${GH_PACKAGES_READ_TOKEN} -Djib.to.auth.username=${DOCKER_USERNAME} -Djib.to.auth.password=${DOCKER_TOKEN}

buildx-docker:
	if [ -z "$GH_PACKAGES_READ_TOKEN" ]; then echo "ERROR: GH_PACKAGES_READ_TOKEN env variable is not defined. Please check project README."; exit 1; fi
	cd app2; docker buildx build --build-arg githubUser=${GH_USER} --build-arg githubPackagesReadToken=${GH_PACKAGES_READ_TOKEN} --platform=${PLATFORMS} --output builder-image . -f Dockerfile.builder
	cd app2; docker buildx build --load --platform=${PLATFORMS} --build-context builder=builder-image . -t ${IMAGE_NAME}

buildx-docker-oci:
	if [ -z "$GH_PACKAGES_READ_TOKEN" ]; then echo "ERROR: GH_PACKAGES_READ_TOKEN env variable is not defined. Please check project README."; exit 1; fi
	cd app2; docker buildx build --build-arg githubUser=${GH_USER} --build-arg githubPackagesReadToken=${GH_PACKAGES_READ_TOKEN} --platform=${PLATFORMS} --output type=oci,dest=builder-image,tar=false . -f Dockerfile.builder
	cd app2; docker buildx build --load --platform=${PLATFORMS} --build-context builder=oci-layout://./builder-image . -t ${IMAGE_NAME}

build-docker:
	if [ -z "$GH_PACKAGES_READ_TOKEN" ]; then echo "ERROR: GH_PACKAGES_READ_TOKEN env variable is not defined. Please check project README."; exit 1; fi
	cd app2; docker build --build-arg githubUser=${GH_USER} --build-arg githubPackagesReadToken=${GH_PACKAGES_READ_TOKEN} --output builder-image . -f Dockerfile.builder
	cd app2; docker build --load --build-context builder=builder-image . -t ${IMAGE_NAME}

test: build-app
	./gradlew test
	cd app2; ./gradlew test

release: build-app
	if [ -z "$VERSION" ]; then echo "ERROR: Usage is: make VERSION=<version> release"; exit 1; fi
	./gradlew -Pversion=$VERSION clean build publish
