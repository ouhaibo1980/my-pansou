#!/bin/bash

# 一键启动脚本 - Docker Compose 方式（推荐）
# 使用方式：./start_docker.sh

set -e

echo "=========================================="
echo "装歌盘搜 - Docker 一键启动"
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
PROJECT_NAME="pansou"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ 错误：未检测到 Docker，请先安装 Docker${NC}"
    echo "   访问：https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查 docker-compose 是否安装
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ 错误：未检测到 Docker Compose${NC}"
    echo "   安装 Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo -e "${GREEN}✅ Docker 环境检查通过${NC}"

# 创建前端 Dockerfile（如果不存在）
if [ ! -f "frontend/Dockerfile" ]; then
    echo ""
    echo -e "${BLUE}📝 创建前端 Dockerfile...${NC}"
    cat > frontend/Dockerfile << 'EOF'
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/package*.json ./
RUN npm install --production
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.* ./
ENV NODE_ENV=production
EXPOSE 3000
CMD ["npm", "start"]
EOF
    echo -e "${GREEN}✅ 前端 Dockerfile 已创建${NC}"
fi

# 更新 docker-compose.yml 添加前端服务
echo ""
echo -e "${BLUE}📝 配置 Docker Compose...${NC}"
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  pansou-backend:
    image: ghcr.io/fish2018/pansou:latest
    container_name: pansou-backend
    restart: unless-stopped
    ports:
      - "8888:8888"
    environment:
      - PORT=8888
      - CACHE_ENABLED=true
      - CACHE_PATH=/app/cache
      - TZ=Asia/Shanghai
      - ASYNC_PLUGIN_ENABLED=true
      - ASYNC_RESPONSE_TIMEOUT=4
      - ASYNC_MAX_BACKGROUND_WORKERS=20
      - ASYNC_MAX_BACKGROUND_TASKS=100
      - ASYNC_CACHE_TTL_HOURS=1
      - ENABLED_PLUGINS=labi,zhizhen,shandian,duoduo,muou,wanou,hunhepan,jikepan,panwiki,pansearch,panta,qupansou,hdr4k,pan666,susu,thepiratebay,xuexizhinan,panyq,ouge,huban,cyg,erxiao,miaoso,fox4k,pianku,clmao,wuji,cldi,xiaozhang,libvio,leijing,xb6v,xys,ddys,hdmoli,yuhuage,u3c3,javdb,clxiong,jutoushe,sdso,xiaoji,xdyh,haisou,bixin,djgou,nyaa,xinjuc,aikanzy,qupanshe,xdpan,discourse,yunsou,qqpd,ahhhhfs,nsgame,gying,quark4k,quarksoo,sousou,ash
    volumes:
      - pansou-cache:/app/cache
    networks:
      - pansou-network
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost:8888/api/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

  pansou-frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: pansou-frontend
    restart: unless-stopped
    ports:
      - "5000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - pansou-backend
    networks:
      - pansou-network
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost:3000"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 30s

volumes:
  pansou-cache:
    name: pansou-cache

networks:
  pansou-network:
    name: pansou-network
EOF
echo -e "${GREEN}✅ Docker Compose 配置完成${NC}"

# 启动服务
echo ""
echo -e "${BLUE}🚀 启动服务...${NC}"

# 使用 docker-compose 或 docker compose
if docker compose version &> /dev/null; then
    docker compose -p "${PROJECT_NAME}" up -d --build
else
    docker-compose -p "${PROJECT_NAME}" up -d --build
fi

# 等待后端启动
echo ""
echo -e "${YELLOW}⏳ 等待服务启动...${NC}"
sleep 10

# 检查服务状态
echo ""
echo -e "${BLUE}🔍 检查服务状态...${NC}"
if docker compose version &> /dev/null; then
    docker compose -p "${PROJECT_NAME}" ps
else
    docker-compose -p "${PROJECT_NAME}" ps
fi

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
echo "   查看日志: docker-compose -p ${PROJECT_NAME} logs -f"
echo "   停止服务: ./stop_docker.sh"
echo "   重启服务: ./restart_docker.sh"
echo ""
echo "=========================================="
