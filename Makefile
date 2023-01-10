REGISTRY=registry
IMAGE_NAME=image-name
IMAGE_TAG=latest

all:
	# You can then tag the image and upload it to a registry of your choice
	@docker build . -t ${IMAGE_NAME}:${IMAGE_TAG}

publish:
	@docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
	@docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
	@docker rmi ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}