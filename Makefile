# docker-pytorch用 Makefile

REPO_NAME = plumiiume/pytorch
IMAGE_NAME = pytorch-local
BASE_IMAGE ?= ubuntu:24.04
PYTHON_VERSION ?= 3.12
PYTORCH_VERSION ?= 2.8.0
TORCHVISION_VERSION ?= 0.23.0
TORCHAUDIO_VERSION ?= 2.8.0
CUDA_PATH ?= cu128

build:
	docker build -t $(IMAGE_NAME) . \
		--target final-slim \
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

# Python 3.12 + PyTorch 2.8.0 + CUDA 12.8
build-py312-pt28-cu128:
	docker build -t $(REPO_NAME):ubuntu24.04-python3.12-pytorch2.8-cuda12.8-runtime . \
		--target build-uv-torch \
		--build-arg PYTHON_VERSION=3.12 \
		--build-arg PYTORCH_VERSION=2.8.0 \
		--build-arg TORCHVISION_VERSION=0.23.0 \
		--build-arg TORCHAUDIO_VERSION=2.8.0 \
		--build-arg CUDA_PATH=cu128
	docker build -t $(REPO_NAME):ubuntu24.04-python3.12-pytorch2.8-cuda12.8-slim-runtime . \
		--target final-slim \
		--build-arg PYTHON_VERSION=3.12 \
		--build-arg PYTORCH_VERSION=2.8.0 \
		--build-arg TORCHVISION_VERSION=0.23.0 \
		--build-arg TORCHAUDIO_VERSION=2.8.0 \
		--build-arg CUDA_PATH=cu128
	docker build -t $(REPO_NAME):ubuntu24.04-python3.12-pytorch2.8-cuda12.8-pyg-runtime . \
		--target final-pyg \
		--build-arg PYTHON_VERSION=3.12 \
		--build-arg PYTORCH_VERSION=2.8.0 \
		--build-arg TORCHVISION_VERSION=0.23.0 \
		--build-arg TORCHAUDIO_VERSION=2.8.0 \
		--build-arg CUDA_PATH=cu128

# Python 3.13 + PyTorch 2.8.0 + CUDA 12.8
build-py313-pt28-cu128:
	docker build -t $(REPO_NAME):ubuntu24.04-python3.13-pytorch2.8-cuda12.8-runtime . \
		--target build-uv-torch \
		--build-arg PYTHON_VERSION=3.13 \
		--build-arg PYTORCH_VERSION=2.8.0 \
		--build-arg TORCHVISION_VERSION=0.23.0 \
		--build-arg TORCHAUDIO_VERSION=2.8.0 \
		--build-arg CUDA_PATH=cu128
	docker build -t $(REPO_NAME):ubuntu24.04-python3.13-pytorch2.8-cuda12.8-slim-runtime . \
		--target final-slim \
		--build-arg PYTHON_VERSION=3.13 \
		--build-arg PYTORCH_VERSION=2.8.0 \
		--build-arg TORCHVISION_VERSION=0.23.0 \
		--build-arg TORCHAUDIO_VERSION=2.8.0 \
		--build-arg CUDA_PATH=cu128

# Python 3.12 + PyTorch 2.9.0 + CUDA 13.0
build-py312-pt29-cu130:
	docker build -t $(REPO_NAME):ubuntu24.04-python3.12-pytorch2.9-cuda13.0-slim-runtime . \
		--target final-slim \
		--build-arg PYTHON_VERSION=3.12 \
		--build-arg PYTORCH_VERSION=2.9.0 \
		--build-arg TORCHVISION_VERSION=0.24.0 \
		--build-arg TORCHAUDIO_VERSION=2.9.0 \
		--build-arg CUDA_PATH=cu130

# Python 3.13 + PyTorch 2.9.0 + CUDA 13.0
build-py313-pt29-cu130:
	docker build -t $(REPO_NAME):ubuntu24.04-python3.13-pytorch2.9-cuda13.0-slim-runtime . \
		--target final-slim \
		--build-arg PYTHON_VERSION=3.13 \
		--build-arg PYTORCH_VERSION=2.9.0 \
		--build-arg TORCHVISION_VERSION=0.24.0 \
		--build-arg TORCHAUDIO_VERSION=2.9.0 \
		--build-arg CUDA_PATH=cu130

# 全バージョンビルド
build-all: build-py312-pt28-cu128 build-py313-pt28-cu128 build-py312-pt29-cu130 build-py313-pt29-cu130

# プッシュターゲット
push-py312-pt28-cu128:
	docker push $(REPO_NAME):ubuntu24.04-python3.12-pytorch2.8-cuda12.8-runtime
	docker push $(REPO_NAME):ubuntu24.04-python3.12-pytorch2.8-cuda12.8-slim-runtime
	docker push $(REPO_NAME):ubuntu24.04-python3.12-pytorch2.8-cuda12.8-pyg-runtime

push-py313-pt28-cu128:
	docker push $(REPO_NAME):ubuntu24.04-python3.13-pytorch2.8-cuda12.8-runtime
	docker push $(REPO_NAME):ubuntu24.04-python3.13-pytorch2.8-cuda12.8-slim-runtime

push-py312-pt29-cu130:
	docker push $(REPO_NAME):ubuntu24.04-python3.12-pytorch2.9-cuda13.0-slim-runtime

push-py313-pt29-cu130:
	docker push $(REPO_NAME):ubuntu24.04-python3.13-pytorch2.9-cuda13.0-slim-runtime

# 全バージョンプッシュ
push-all: push-py312-pt28-cu128 push-py313-pt28-cu128 push-py312-pt29-cu130 push-py313-pt29-cu130

# ビルド＆プッシュ
build-push-all: build-all push-all
