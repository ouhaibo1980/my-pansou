#!/bin/bash

# 一键启动脚本 - 完整版（包含前端和后端）
# 使用方式：./start_full_docker.sh

set -e

echo "=========================================="
echo "装歌盘搜 - Docker 完整启动（前端+后端）"
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
BACKEND_PORT=8888
FRONTEND_PORT=5000
BACKEND_IMAGE="ghcr.io/fish2018/pansou:latest"
BACKEND_CONTAINER="pansou-backend"
FRONTEND_CONTAINER="pansou-frontend"
NETWORK_NAME="pansou-network"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ 错误：未检测到 Docker，请先安装 Docker${NC}"
    echo "   访问：https://docs.docker.com/get-docker/"
    exit 1
fi

echo -e "${GREEN}✅ Docker 已安装${NC}"

# 创建网络
if ! docker network ls --format '{{.Name}}' | grep -q "^${NETWORK_NAME}$"; then
    echo ""
    echo -e "${BLUE}🌐 创建 Docker 网络...${NC}"
    docker network create "${NETWORK_NAME}"
fi

# 停止并删除旧容器
echo ""
echo -e "${YELLOW}📦 清理旧容器...${NC}"
docker stop "${BACKEND_CONTAINER}" "${FRONTEND_CONTAINER}" 2>/dev/null || true
docker rm "${BACKEND_CONTAINER}" "${FRONTEND_CONTAINER}" 2>/dev/null || true
echo -e "${GREEN}✅ 旧容器已清理${NC}"

# 启动后端容器
echo ""
echo -e "${BLUE}🚀 启动后端 API 服务...${NC}"
docker run -d \
    --name "${BACKEND_CONTAINER}" \
    --network "${NETWORK_NAME}" \
    --restart unless-stopped \
    -p "${BACKEND_PORT}:8888" \
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
    "${BACKEND_IMAGE}"

# 等待后端启动
echo ""
echo -e "${YELLOW}⏳ 等待后端服务启动...${NC}"
sleep 5

# 检查后端健康状态
echo -e "${BLUE}🔍 检查后端健康状态...${NC}"
MAX_RETRIES=10
RETRY=0
while [ $RETRY -lt $MAX_RETRIES ]; do
    if curl -s http://localhost:${BACKEND_PORT}/api/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 后端服务就绪${NC}"
        break
    fi
    RETRY=$((RETRY+1))
    echo -e "${YELLOW}   等待中... ($RETRY/$MAX_RETRIES)${NC}"
    sleep 2
done

if [ $RETRY -eq $MAX_RETRIES ]; then
    echo -e "${RED}❌ 后端服务启动失败${NC}"
    echo "请查看日志：docker logs ${BACKEND_CONTAINER}"
    exit 1
fi

# 构建并启动前端容器
echo ""
echo -e "${BLUE}🎨 构建并启动前端服务...${NC}"
docker run -d \
    --name "${FRONTEND_CONTAINER}" \
    --network "${NETWORK_NAME}" \
    --restart unless-stopped \
    -p "${FRONTEND_PORT}:3000" \
    -e NEXT_PUBLIC_API_URL=http://${BACKEND_CONTAINER}:8888 \
    node:18-alpine sh -c "
        apk add --no-cache git &&
        cd /app &&
        git clone https://github.com/ouhaibo1980/my-pansou.git . &&
        cd frontend &&
        npm install &&
        npm run build &&
        npm start
    "

# 等待前端启动
echo ""
echo -e "${YELLOW}⏳ 等待前端服务启动...${NC}"
sleep 10

# 输出启动信息
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
echo "   查看后端日志: docker logs -f ${BACKEND_CONTAINER}"
echo "   查看前端日志: docker logs -f ${FRONTEND_CONTAINER}"
echo ""
echo "   停止服务: ./stop_docker.sh"
echo "   重启服务: ./restart_docker.sh"
echo ""
echo "=========================================="
