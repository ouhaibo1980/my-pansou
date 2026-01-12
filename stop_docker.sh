#!/bin/bash

# 停止 Docker 服务脚本
# 使用方式：./stop_docker.sh

set -e

echo "=========================================="
echo "停止装歌盘搜 Docker 服务"
echo "=========================================="

PROJECT_NAME="pansou"

echo ""
echo "🛑 停止服务..."

# 使用 docker-compose 或 docker compose
if docker compose version &> /dev/null; then
    docker compose -p "${PROJECT_NAME}" down
else
    docker-compose -p "${PROJECT_NAME}" down
fi

echo ""
echo "=========================================="
echo "✅ 服务已停止"
echo "=========================================="
