IMAGE_NAME=multiple-docker-build
PLATFORMS=`([ "$(uname -m)" = "x86_64" ] && echo "linux/amd64") || echo "linux/arm64"`

all: clean buildx-docker-oci

clean:
	./gradlew clean
	docker image rm -f ${IMAGE_NAME}
	rm -rf builder-image

buildx-docker:
	./gradlew build
	docker buildx build --platform=${PLATFORMS} --output builder-image . -f Dockerfile.builder
	docker buildx build --load --platform=${PLATFORMS} --build-context builder=builder-image . -t ${IMAGE_NAME} 

buildx-docker-oci:
	./gradlew build
	docker buildx build --platform=${PLATFORMS} --output type=oci,dest=builder-image,tar=false . -f Dockerfile.builder
	docker buildx build --load --platform=${PLATFORMS} --build-context builder=oci-layout://./builder-image . -t ${IMAGE_NAME} 

build-docker:
	./gradlew build
	docker build --output builder-image . -f Dockerfile.builder
	docker build --load --build-context builder=builder-image . -t ${IMAGE_NAME} 

build-docker-oci:
	./gradlew build
	docker build --output type=oci,dest=builder-image,tar=false . -f Dockerfile.builder
	docker build --load --build-context builder=oci-layout://./builder-image . -t ${IMAGE_NAME} 

test: buildx-docker
	./gradlew clean test