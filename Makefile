# docker-pytorch用 Makefile

IMAGE_NAME = pytorch-local
BASE_IMAGE ?= ubuntu:24.04
PYTHON_VERSION ?= 3.12
PYTORCH_VERSION ?= 2.8.0
TORCHVISION_VERSION ?= 0.23.0
TORCHAUDIO_VERSION ?= 2.8.0
CUDA_PATH ?= cu128

build:
	docker build -t $(IMAGE_NAME) . \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
		--build-arg PYTORCH_VERSION=$(PYTORCH_VERSION) \
		--build-arg TORCHVISION_VERSION=$(TORCHVISION_VERSION) \
		--build-arg TORCHAUDIO_VERSION=$(TORCHAUDIO_VERSION) \
		--build-arg CUDA_PATH=$(CUDA_PATH)

run:
	docker run --rm -it $(IMAGE_NAME)

shell:
	docker run --rm -it $(IMAGE_NAME) /bin/bash

clean:
	docker rmi $(IMAGE_NAME) || true

rebuild:
	$(MAKE) clean
	$(MAKE) build
