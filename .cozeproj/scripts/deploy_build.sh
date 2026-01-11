#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

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
