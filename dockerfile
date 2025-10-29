# syntax=docker/dockerfile:1.4

ARG BASE_IMAGE=ubuntu:24.04
# or
# ARG BASE_IMAGE=nvidia/cuda:12.8-runtime-ubuntu24.04
# see https://hub.docker.com/r/nvidia/cuda

FROM ${BASE_IMAGE} AS base-with-env

ENV PATH "/opt/uv/bin:/opt/uv/.venv/bin:$PATH"
ENV UV_PYTHON_INSTALL_DIR /opt/uv/python
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LD_LIBRARY_PATH

FROM base-with-env AS build-base

RUN     apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            build-essential \
            ca-certificates \
            ccache \
            curl \
            git \
            libjpeg-dev \
            libpng-dev \
    &&  rm -rf /var/lib/apt/lists/*

RUN     /usr/sbin/update-ccache-symlinks \
    &&  mkdir -p /opt/ccache \
    &&  ccache --set-config=cache_dir=/opt/ccache

LABEL   com.nvidia.volumes.needed="nvidia_driver"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV PYTORCH_VERSION ${PYTORCH_VERSION}

FROM build-base AS build-uv-torch

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /opt/uv/bin/

ARG PYTHON_VERSION=3.12
ARG PYTORCH_VERSION=2.8.0
ARG TORCHVISION_VERSION=0.23.0
ARG TORCHAUDIO_VERSION=2.8.0
ARG CUDA_PATH=cu128

WORKDIR /opt/uv
RUN     uv init --bare --python ${PYTHON_VERSION} --managed-python
RUN     uv add --python ${PYTHON_VERSION} --no-cache \
            --index https://download.pytorch.org/whl/${CUDA_PATH} \
            --index-strategy unsafe-best-match \
            torch==${PYTORCH_VERSION}
RUN     uv add --python ${PYTHON_VERSION} --no-cache \
            --index https://download.pytorch.org/whl/${CUDA_PATH} \
            --index-strategy unsafe-best-match \
            torchvision==${TORCHVISION_VERSION} \
            torchaudio==${TORCHAUDIO_VERSION}

FROM build-uv-torch AS build-uv-pyg

ARG PYTORCH_VERSION=2.8.0
ARG CUDA_PATH=cu128

RUN     uv add --no-cache \
            --find-links https://data.pyg.org/whl/torch-${PYTORCH_VERSION}+${CUDA_PATH}.html \
            --index-strategy unsafe-best-match \
            --no-build-isolation \
            pyg_lib \
            torch_scatter \
            torch_sparse \
            torch_cluster \
            torch_spline_conv \
            torch_geometric

FROM build-uv-torch AS final-slim-runtime
WORKDIR /workspace

FROM build-uv-pyg AS final-pyg-runtime
WORKDIR /workspace
