# docker-pytorch用 CMakeLists.txt
cmake_minimum_required(VERSION 3.15)
project(docker_pytorch NONE)

# Dockerビルド用カスタムコマンド
set(REPO_NAME plumiiume/pytorch)
set(IMAGE_NAME pytorch-local)
set(BASE_IMAGE ubuntu:24.04)
set(PYTHON_VERSION 3.12)
set(PYTORCH_VERSION 2.8.0)
set(TORCHVISION_VERSION 0.23.0)
set(TORCHAUDIO_VERSION 2.8.0)
set(CUDA_PATH cu128)

add_custom_target(build
    COMMAND docker build -t ${IMAGE_NAME} .
        --target final-slim
        --build-arg BASE_IMAGE=${BASE_IMAGE}
        --build-arg PYTHON_VERSION=${PYTHON_VERSION}
        --build-arg PYTORCH_VERSION=${PYTORCH_VERSION}
        --build-arg TORCHVISION_VERSION=${TORCHVISION_VERSION}
        --build-arg TORCHAUDIO_VERSION=${TORCHAUDIO_VERSION}
        --build-arg CUDA_PATH=${CUDA_PATH}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(run
    COMMAND docker run --rm -it ${IMAGE_NAME}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(shell
    COMMAND docker run --rm -it ${IMAGE_NAME} /bin/bash
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(clean
    COMMAND docker rmi ${IMAGE_NAME} || exit 0
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_custom_target(rebuild
    COMMAND ${CMAKE_COMMAND} --build . --target clean
    COMMAND ${CMAKE_COMMAND} --build . --target build
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# Python 3.12 + PyTorch 2.8.0 + CUDA 12.8
add_custom_target(build-py312-pt28-cu128
    COMMAND docker build -t ${REPO_NAME}:ubuntu24.04-python3.12-pytorch2.8-cuda12.8-runtime .
        --target build-uv-torch
        --build-arg PYTHON_VERSION=3.12
        --build-arg PYTORCH_VERSION=2.8.0
        --build-arg TORCHVISION_VERSION=0.23.0
        --build-arg TORCHAUDIO_VERSION=2.8.0
        --build-arg CUDA_PATH=cu128
    COMMAND docker build -t ${REPO_NAME}:ubuntu24.04-python3.12-pytorch2.8-cuda12.8-slim-runtime .
        --target final-slim
        --build-arg PYTHON_VERSION=3.12
        --build-arg PYTORCH_VERSION=2.8.0
        --build-arg TORCHVISION_VERSION=0.23.0
        --build-arg TORCHAUDIO_VERSION=2.8.0
        --build-arg CUDA_PATH=cu128
    COMMAND docker build -t ${REPO_NAME}:ubuntu24.04-python3.12-pytorch2.8-cuda12.8-pyg-runtime .
        --target final-pyg
        --build-arg PYTHON_VERSION=3.12
        --build-arg PYTORCH_VERSION=2.8.0
        --build-arg TORCHVISION_VERSION=0.23.0
        --build-arg TORCHAUDIO_VERSION=2.8.0
        --build-arg CUDA_PATH=cu128
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# Python 3.13 + PyTorch 2.8.0 + CUDA 12.8
add_custom_target(build-py313-pt28-cu128
    COMMAND docker build -t ${REPO_NAME}:ubuntu24.04-python3.13-pytorch2.8-cuda12.8-runtime .
        --target build-uv-torch
        --build-arg PYTHON_VERSION=3.13
        --build-arg PYTORCH_VERSION=2.8.0
        --build-arg TORCHVISION_VERSION=0.23.0
        --build-arg TORCHAUDIO_VERSION=2.8.0
        --build-arg CUDA_PATH=cu128
    COMMAND docker build -t ${REPO_NAME}:ubuntu24.04-python3.13-pytorch2.8-cuda12.8-slim-runtime .
        --target final-slim
        --build-arg PYTHON_VERSION=3.13
        --build-arg PYTORCH_VERSION=2.8.0
        --build-arg TORCHVISION_VERSION=0.23.0
        --build-arg TORCHAUDIO_VERSION=2.8.0
        --build-arg CUDA_PATH=cu128
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# Python 3.12 + PyTorch 2.9.0 + CUDA 13.0
add_custom_target(build-py312-pt29-cu130
    COMMAND docker build -t ${REPO_NAME}:ubuntu24.04-python3.12-pytorch2.9-cuda13.0-slim-runtime .
        --target final-slim
        --build-arg PYTHON_VERSION=3.12
        --build-arg PYTORCH_VERSION=2.9.0
        --build-arg TORCHVISION_VERSION=0.24.0
        --build-arg TORCHAUDIO_VERSION=2.9.0
        --build-arg CUDA_PATH=cu130
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# Python 3.13 + PyTorch 2.9.0 + CUDA 13.0
add_custom_target(build-py313-pt29-cu130
    COMMAND docker build -t ${REPO_NAME}:ubuntu24.04-python3.13-pytorch2.9-cuda13.0-slim-runtime .
        --target final-slim
        --build-arg PYTHON_VERSION=3.13
        --build-arg PYTORCH_VERSION=2.9.0
        --build-arg TORCHVISION_VERSION=0.24.0
        --build-arg TORCHAUDIO_VERSION=2.9.0
        --build-arg CUDA_PATH=cu130
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# 全バージョンビルド
add_custom_target(build-all
    DEPENDS build-py312-pt28-cu128 build-py313-pt28-cu128 build-py312-pt29-cu130 build-py313-pt29-cu130
)
