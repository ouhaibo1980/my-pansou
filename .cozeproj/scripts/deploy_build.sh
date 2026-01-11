#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

# 添加常见 Go 安装路径到 PATH
export PATH="/usr/local/go/bin:$PATH:/usr/local/bin:$PATH"

# 检查 go 是否可用
if ! command -v go &> /dev/null; then
    echo "ERROR: Go command not found in PATH" >&2
    echo "Current PATH: $PATH" >&2
    echo "Searching for go binary..." >&2
    find /usr -name "go" -type f 2>/dev/null | head -5 >&2 || true
    exit 1
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
