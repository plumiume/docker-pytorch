# docker-pytorch

PyTorch環境をDockerで簡単に構築・運用できる最小セットのリポジトリです。

## 特徴
- ベースイメージやPyTorchバージョンを柔軟に指定可能
- GPU/CPU両対応（nvidia/cudaイメージ利用可）
- 必要なPythonパッケージはdockerfileで一括管理
- Makefile/CMakeLists.txtによるバッチ的なビルド・実行

## 主要ファイル
- `dockerfile` : PyTorch環境のビルド手順
- `Makefile` : Dockerビルド/実行/クリーン等のバッチ操作
- `CMakeLists.txt` : CMake経由でDocker操作（VS統合向け）

## 使い方
### Dockerイメージのビルド
```sh
docker build -t pytorch-local .
```
### コンテナの起動
```sh
docker run --rm -it pytorch-local
```
### Makefile利用例
```sh
make build   # ビルド
make run     # 実行
make shell   # シェル起動
make clean   # イメージ削除
make rebuild # クリーン→再ビルド
```
### CMake利用例（Visual Studio等）
- `build`/`run`/`shell`/`clean`/`rebuild` ターゲットを選択

## ビルド引数
- BASE_IMAGE, PYTHON_VERSION, PYTORCH_VERSION, TORCHVISION_VERSION, TORCHAUDIO_VERSION, CUDA_PATH
- 例: `docker build -t pytorch-local . --build-arg PYTORCH_VERSION=2.7.0`

## よくある課題
- GPU利用時はDocker/NVIDIAドライバの互換性に注意
- パーミッションや依存関係エラーはベースイメージ・パッケージ見直しで解決

## 参考
- [PyTorch Docker Hub](https://hub.docker.com/r/pytorch/pytorch)
- [Docker公式ドキュメント](https://docs.docker.com/)

---
このREADMEはAIエージェントによる自動生成です。内容の追加・修正要望はご連絡ください。
