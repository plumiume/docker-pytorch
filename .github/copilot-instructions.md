# Copilot Instructions for docker-pytorch

## プロジェクト概要
このリポジトリは、PyTorch環境をDockerで構築・運用するための最小限のセットアップを提供します。主要構成要素は `dockerfile`、`Makefile`、`CMakeLists.txt` です。

## 主要ファイル
- `dockerfile`: PyTorch環境のビルド手順。ベースイメージ、パッケージインストール、環境変数設定など。
- `Makefile`: Dockerビルド/実行/クリーン等のバッチ操作。
- `CMakeLists.txt`: CMake経由でDocker操作（Visual Studio統合向け）。

## ワークフロー
- **ビルド**: 以下のコマンドでDockerイメージをビルドします。
  ```sh
  docker build -t pytorch-local .
  ```
- **実行**: ビルドしたイメージを使ってコンテナを起動します。
  ```sh
  docker run --rm -it pytorch-local
  ```
- **Makefile利用**: `make build`/`make run`/`make shell`/`make clean`/`make rebuild` でバッチ操作。
- **CMake利用**: Visual Studio等から `build`/`run`/`shell`/`clean`/`rebuild` ターゲットを選択。
- **カスタマイズ**: `dockerfile` のビルド引数やパッケージを編集して、必要なPythonパッケージやPyTorchバージョンを変更できます。

## 開発パターン・注意点
- **依存管理**: 追加パッケージは `dockerfile` 内で `pip install` または `uv add` でインストール。
- **バージョン指定**: PyTorchやCUDAのバージョンはベースイメージやビルド引数で明示的に指定。
- **GPU利用**: GPU対応が必要な場合は、`nvidia/cuda` ベースイメージや `--gpus all` オプションを利用。
- **ビルド引数**: `BASE_IMAGE`, `PYTHON_VERSION`, `PYTORCH_VERSION`, `TORCHVISION_VERSION`, `TORCHAUDIO_VERSION`, `CUDA_PATH` などを `docker build --build-arg` で指定可能。
- **ファイル構成**: プロジェクト拡張時は `requirements.txt` や `src/` ディレクトリ追加を検討。

## 例: dockerfile の基本構造
```Dockerfile
# syntax=docker/dockerfile:1.4
ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}
ARG PYTHON_VERSION=3.12
ARG PYTORCH_VERSION=2.8.0
ARG TORCHVISION_VERSION=0.23.0
ARG TORCHAUDIO_VERSION=2.8.0
ARG CUDA_PATH=cu128
# ...パッケージインストールや環境変数設定...
```

## よくある課題
- GPU利用時はDocker/NVIDIAドライバの互換性に注意。
- パーミッションや依存関係エラーはベースイメージ・パッケージ見直しで解決。

## 参考
- [PyTorch Docker Hub][pytorch-hub]
- [Docker公式ドキュメント][docker-docs]
- プロジェクトルートのREADME.mdも参照

[pytorch-hub]: https://hub.docker.com/r/pytorch/pytorch
[docker-docs]: https://docs.docker.com/

---
このドキュメントはAIエージェントによる自動生成です。内容に不明点や追加要望があればご指摘ください。
