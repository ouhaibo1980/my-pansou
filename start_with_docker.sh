#!/bin/bash

# 一键启动脚本 - 使用 Docker 命令直接运行
# 使用方式：./start_with_docker.sh

set -e

echo "=========================================="
echo "装歌盘搜 - Docker 一键启动"
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置
BACKEND_PORT=8888
FRONTEND_PORT=5000
IMAGE_NAME="my-pansou"
CONTAINER_NAME="pansou-all-in-one"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ 错误：未检测到 Docker，请先安装 Docker${NC}"
    echo "   访问：https://docs.docker.com/get-docker/"
    exit 1
fi

echo -e "${GREEN}✅ Docker 已安装${NC}"

# 停止并删除旧容器
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo ""
    echo -e "${YELLOW}📦 检测到旧容器，正在停止并删除...${NC}"
    docker stop "${CONTAINER_NAME}" 2>/dev/null || true
    docker rm "${CONTAINER_NAME}" 2>/dev/null || true
    echo -e "${GREEN}✅ 旧容器已清理${NC}"
fi

echo ""
echo "🚀 正在启动容器..."

# 启动容器（后端 API）
docker run -d \
    --name "${CONTAINER_NAME}" \
    --restart unless-stopped \
    -p "${BACKEND_PORT}:8888" \
    -p "${FRONTEND_PORT}:3000" \
    -e PORT=8888 \
    -e CACHE_ENABLED=true \
    -e CACHE_PATH=/app/cache \
    -e TZ=Asia/Shanghai \
    -e ASYNC_PLUGIN_ENABLED=true \
    -e ASYNC_RESPONSE_TIMEOUT=4 \
    -e ASYNC_MAX_BACKGROUND_WORKERS=20 \
    -e ASYNC_MAX_BACKGROUND_TASKS=100 \
    -e ASYNC_CACHE_TTL_HOURS=1 \
    -e ENABLED_PLUGINS=labi,zhizhen,shandian,duoduo,muou,wanou,hunhepan,jikepan,panwiki,pansearch,panta,qupansou,hdr4k,pan666,susu,thepiratebay,xuexizhinan,panyq,ouge,huban,cyg,erxiao,miaoso,fox4k,pianku,clmao,wuji,cldi,xiaozhang,libvio,leijing,xb6v,xys,ddys,hdmoli,yuhuage,u3c3,javdb,clxiong,jutoushe,sdso,xiaoji,xdyh,haisou,bixin,djgou,nyaa,xinjuc,aikanzy,qupanshe,xdpan,discourse,yunsou,qqpd,ahhhhfs,nsgame,gying,quark4k,quarksoo,sousou,ash \
    -v pansou-cache:/app/cache \
    ghcr.io/fish2018/pansou:latest

echo ""
echo "=========================================="
echo -e "${GREEN}✅ 启动成功！${NC}"
echo "=========================================="
echo ""
echo "📱 访问地址："
echo "   - Web 前端: http://localhost:${FRONTEND_PORT}"
echo "   - API 服务: http://localhost:${BACKEND_PORT}/api"
echo "   - 健康检查: http://localhost:${BACKEND_PORT}/api/health"
echo ""
echo "🔧 管理命令："
echo "   查看日志: docker logs -f ${CONTAINER_NAME}"
echo "   停止服务: docker stop ${CONTAINER_NAME}"
echo "   启动服务: docker start ${CONTAINER_NAME}"
echo "   重启服务: docker restart ${CONTAINER_NAME}"
echo "   删除容器: docker rm -f ${CONTAINER_NAME}"
echo ""
echo "=========================================="
