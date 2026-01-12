#!/bin/bash

# 装歌盘搜 - 快速启动脚本
# 使用方式：./quick_start.sh

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=========================================="
echo "装歌盘搜 - 快速启动"
echo "=========================================="
echo ""

# 1. 检查环境
echo -e "${BLUE}🔍 检查环境...${NC}"

# 检查 pnpm
if ! command -v pnpm &> /dev/null; then
    echo -e "${RED}❌ 未检测到 pnpm${NC}"
    echo "   请先安装: npm install -g pnpm"
    exit 1
fi

# 检查 go
if ! command -v go &> /dev/null; then
    echo -e "${RED}❌ 未检测到 Go${NC}"
    echo "   请先安装 Go: https://go.dev/dl/"
    exit 1
fi

# 检查 pm2
if ! command -v pm2 &> /dev/null; then
    echo -e "${RED}❌ 未检测到 PM2${NC}"
    echo "   请先安装: npm install -g pm2"
    exit 1
fi

echo -e "${GREEN}✅ 环境检查通过${NC}"

# 2. 启动后端
echo ""
echo -e "${BLUE}🔧 启动后端...${NC}"

if [ ! -f "./pansou" ]; then
    echo -e "${YELLOW}⚠️  后端二进制文件不存在，正在编译...${NC}"
    go build -o pansou main.go
fi

# 停止旧进程
pm2 delete pansou-backend 2>/dev/null || true

# 启动后端
pm2 start ./pansou --name "pansou-backend"
echo -e "${GREEN}✅ 后端已启动${NC}"

# 3. 启动前端
echo ""
echo -e "${BLUE}🔧 启动前端...${NC}"
cd frontend

# 停止旧进程
pm2 delete pansou-frontend 2>/dev/null || true

# 启动前端
pm2 start npm --name "pansou-frontend" -- start
cd ..
echo -e "${GREEN}✅ 前端已启动${NC}"

# 4. 设置开机自启
echo ""
echo -e "${BLUE}⚙️  设置开机自启...${NC}"
pm2 save
echo -e "${GREEN}✅ 已设置开机自启${NC}"

# 5. 输出启动信息
echo ""
echo "=========================================="
echo -e "${GREEN}✅ 启动成功！${NC}"
echo "=========================================="
echo ""
echo "📱 访问地址："
echo "   - Web 前端: http://localhost:3000"
echo "   - API 服务: http://localhost:8888/api"
echo ""
echo "🔧 管理命令："
echo "   查看状态: pm2 list"
echo "   查看日志: pm2 logs"
echo "   重启服务: pm2 restart all"
echo "   停止服务: pm2 stop all"
echo ""
echo "=========================================="
