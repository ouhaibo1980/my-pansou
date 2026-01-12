#!/bin/bash

# 重启 Docker 服务脚本
# 使用方式：./restart_docker.sh

set -e

echo "=========================================="
echo "重启装歌盘搜 Docker 服务"
echo "=========================================="

PROJECT_NAME="pansou"

echo ""
echo "🔄 重启服务..."

# 使用 docker-compose 或 docker compose
if docker compose version &> /dev/null; then
    docker compose -p "${PROJECT_NAME}" restart
else
    docker-compose -p "${PROJECT_NAME}" restart
fi

echo ""
echo "=========================================="
echo "✅ 服务已重启"
echo "=========================================="
echo ""
echo "📱 访问地址："
echo "   - Web 前端: http://localhost:5000"
echo "   - API 服务: http://localhost:8888/api"
echo ""
echo "🔧 查看日志："
echo "   docker-compose -p ${PROJECT_NAME} logs -f"
echo ""
echo "=========================================="
