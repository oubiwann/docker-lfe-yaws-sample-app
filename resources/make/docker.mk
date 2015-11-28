IMAGE_TAG = oubiwann/lfe-yaws-sample-app
IMAGE_VERSION = latest

docker-build:
	docker build -t $(IMAGE_TAG):$(IMAGE_VERSION) .

docker-shell:
	docker run -i -t $(IMAGE_TAG):$(IMAGE_VERSION) bash

docker-run:
	docker run -p 5099:5099 -t $(IMAGE_TAG):$(IMAGE_VERSION)

docker-push:
	docker push $(IMAGE_TAG):$(IMAGE_VERSION)
