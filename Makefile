IMAGE_NAME=multiple-docker-build
PLATFORMS=`([ "$(uname -m)" = "x86_64" ] && echo "linux/amd64") || echo "linux/arm64"`
GH_USER=`git config user.name`
GH_PACKAGES_READ_TOKEN=`./gradlew printGithubPackagesReadToken -q`
VERSION=

all: clean test

clean:
	./gradlew clean
	docker image rm -f ${IMAGE_NAME}
	rm -rf builder-image

build:
	if [ -z "$GH_PACKAGES_READ_TOKEN" ]; then echo "ERROR: GH_PACKAGES_READ_TOKEN env variable is not defined. Please check project README."; exit 1; fi
	./gradlew build

buildx-docker:
	docker buildx build --build-arg githubUser=${GH_USER} --build-arg githubPackagesReadToken=${GH_PACKAGES_READ_TOKEN} --platform=${PLATFORMS} --output builder-image . -f Dockerfile.builder
	docker buildx build --load --platform=${PLATFORMS} --build-context builder=builder-image . -t ${IMAGE_NAME}

buildx-docker-oci:
	docker buildx build --build-arg githubUser=${GH_USER} --build-arg githubPackagesReadToken=${GH_PACKAGES_READ_TOKEN} --platform=${PLATFORMS} --output type=oci,dest=builder-image,tar=false . -f Dockerfile.builder
	docker buildx build --load --platform=${PLATFORMS} --build-context builder=oci-layout://./builder-image . -t ${IMAGE_NAME}

build-docker:
	docker build --build-arg githubUser=${GH_USER} --build-arg githubPackagesReadToken=${GH_PACKAGES_READ_TOKEN} --output builder-image . -f Dockerfile.builder
	docker build --load --build-context builder=builder-image . -t ${IMAGE_NAME} 

test: buildx-docker
	./gradlew clean test

release: build
	if [ -z "$VERSION" ]; then echo "ERROR: Usage is: make VERSION=<version> release"; exit 1; fi
	./gradlew -Pversion=$VERSION clean build publish
