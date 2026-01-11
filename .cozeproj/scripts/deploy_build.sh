#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

# 添加常见 Go 安装路径到 PATH（包括自动安装的路径）
export PATH="/tmp/go/bin:/usr/local/go/bin:$PATH:/usr/local/bin:$PATH"

# 定义 Go 版本和安装路径
GO_VERSION="1.24.0"
GO_INSTALL_DIR="/tmp/go"

# 检查 go 是否可用，如果不可用则自动安装
if ! command -v go &> /dev/null; then
    echo "Go not found, installing Go ${GO_VERSION}..." >&2
    echo "Current PATH: $PATH" >&2

    # 下载 Go
    cd /tmp
    GO_ARCH="linux-amd64"
    GO_TARBALL="go${GO_VERSION}.${GO_ARCH}.tar.gz"
    GO_URL="https://dl.google.com/go/${GO_TARBALL}"

    echo "Downloading Go from ${GO_URL}..." >&2
    if ! curl -L "${GO_URL}" -o "${GO_TARBALL}"; then
        echo "ERROR: Failed to download Go" >&2
        exit 1
    fi

    # 解压 Go
    echo "Extracting Go..." >&2
    if ! tar -xzf "${GO_TARBALL}"; then
        echo "ERROR: Failed to extract Go" >&2
        exit 1
    fi

    # 添加 Go 到 PATH
    export PATH="/tmp/go/bin:$PATH"
    echo "Go installed to /tmp/go/bin" >&2

    # 清理
    cd "${COZE_WORKSPACE_PATH}"
fi

echo "Go version: $(go version)"

echo "Building backend..."
export GOPROXY=https://goproxy.cn,direct
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o pansou .

echo "Installing frontend dependencies..."
cd frontend
pnpm install

echo "Building frontend..."
pnpm build

cd ..

echo "Build completed successfully!"
