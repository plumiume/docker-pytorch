# docker-pytorch用 CMakeLists.txt
cmake_minimum_required(VERSION 3.15)
project(docker_pytorch NONE)

# Dockerビルド用カスタムコマンド
set(IMAGE_NAME pytorch-local)
set(BASE_IMAGE ubuntu:24.04)
set(PYTHON_VERSION 3.12)
set(PYTORCH_VERSION 2.8.0)
set(TORCHVISION_VERSION 0.23.0)
set(TORCHAUDIO_VERSION 2.8.0)
set(CUDA_PATH cu128)

add_custom_target(build
    COMMAND docker build -t ${IMAGE_NAME} .
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
