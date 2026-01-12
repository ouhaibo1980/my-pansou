#!/bin/bash

# 装歌盘搜 - 快速启动脚本
# 使用方式：./quick_start.sh --name="项目名称" 或 ./quick_start.sh ou="项目名称"

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认配置
DEFAULT_PROJECT_NAME="装歌盘搜"

# 解析参数
for arg in "$@"; do
    case $arg in
        --name=*|-n=*)
            PROJECT_NAME="${arg#*=}"
            shift
            ;;
        ou=*)
            PROJECT_NAME="${arg#*=}"
            shift
            ;;
        *)
            ;;
    esac
done

# 如果没有指定项目名称，使用默认值
PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}"

echo "=========================================="
echo "$PROJECT_NAME - 快速启动"
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

# 1.5 配置国内镜像源
echo ""
echo -e "${BLUE}⚙️  配置国内镜像源...${NC}"
pnpm config set registry https://registry.npmmirror.com
export GOPROXY=https://goproxy.cn,direct
echo -e "${GREEN}✅ 镜像源配置完成${NC}"

# 2. 启动后端
echo ""
echo -e "${BLUE}🔧 启动后端...${NC}"

# 确保在项目根目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 检查 go.mod 文件是否存在
if [ ! -f "go.mod" ]; then
    echo -e "${RED}❌ 错误：未找到 go.mod 文件${NC}"
    echo -e "${RED}   当前目录：$(pwd)${NC}"
    echo -e "${YELLOW}   请确保在项目根目录下运行此脚本${NC}"
    exit 1
fi

if [ ! -f "./pansou" ]; then
    echo -e "${YELLOW}⚠️  后端二进制文件不存在，正在编译...${NC}"
    go build -o pansou main.go
fi

# 停止旧进程
pm2 delete "${PROJECT_NAME}-backend" 2>/dev/null || true

# 启动后端
pm2 start ./pansou --name "${PROJECT_NAME}-backend"
echo -e "${GREEN}✅ 后端已启动${NC}"

# 3. 启动前端
echo ""
echo -e "${BLUE}🔧 启动前端...${NC}"
cd frontend

# 生成前端配置
echo "   - 项目名称: $PROJECT_NAME"
cat > .env.local << EOF
NEXT_PUBLIC_APP_NAME=$PROJECT_NAME
EOF

# 停止旧进程
pm2 delete "${PROJECT_NAME}-frontend" 2>/dev/null || true

# 启动前端
pm2 start npm --name "${PROJECT_NAME}-frontend" -- start
cd "$SCRIPT_DIR"
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
