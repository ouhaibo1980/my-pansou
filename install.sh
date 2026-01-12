#!/bin/bash

# 装歌盘搜 - 快速安装脚本
# 使用方式：./install.sh

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
PROJECT_DIR="/www/wwwroot/pansou"
FRONTEND_PORT=3000
BACKEND_PORT=8888

echo "=========================================="
echo "装歌盘搜 - 快速安装脚本"
echo "=========================================="
echo ""

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ 错误：请使用 root 用户运行此脚本${NC}"
    echo "   使用方式：sudo ./install.sh"
    exit 1
fi

# 1. 检测宝塔面板
echo -e "${BLUE}🔍 检测宝塔面板...${NC}"
if command -v bt &> /dev/null; then
    echo -e "${GREEN}✅ 检测到宝塔面板${NC}"
    BT_INSTALLED=true
else
    echo -e "${YELLOW}⚠️  未检测到宝塔面板${NC}"
    echo -e "${YELLOW}   将使用通用安装方式${NC}"
    BT_INSTALLED=false
fi

# 2. 检测并安装 Node.js 和 PM2
echo ""
echo -e "${BLUE}📦 检测 Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠️  未检测到 Node.js，正在安装...${NC}"
    if [ "$BT_INSTALLED" = true ]; then
        # 宝塔方式安装
        bt install pm2_manager
    else
        # 通用方式安装
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt-get install -y nodejs
        npm install -g pm2
    fi
fi
echo -e "${GREEN}✅ Node.js 已安装${NC}"

if ! command -v pm2 &> /dev/null; then
    echo -e "${YELLOW}⚠️  未检测到 PM2，正在安装...${NC}"
    npm install -g pm2
fi
echo -e "${GREEN}✅ PM2 已安装${NC}"

# 3. 检测并安装 Go
echo ""
echo -e "${BLUE}📦 检测 Go...${NC}"
if ! command -v go &> /dev/null; then
    echo -e "${YELLOW}⚠️  未检测到 Go，正在安装...${NC}"
    wget -O /tmp/go1.24.linux-amd64.tar.gz https://go.dev/dl/go1.24.0.linux-amd64.tar.gz
    tar -C /usr/local -xzf /tmp/go1.24.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
    source /etc/profile
    rm /tmp/go1.24.linux-amd64.tar.gz
fi
echo -e "${GREEN}✅ Go 已安装${NC}"

# 4. 检测并安装 pnpm
echo ""
echo -e "${BLUE}📦 检测 pnpm...${NC}"
if ! command -v pnpm &> /dev/null; then
    echo -e "${YELLOW}⚠️  未检测到 pnpm，正在安装...${NC}"
    npm install -g pnpm
fi
echo -e "${GREEN}✅ pnpm 已安装${NC}"

# 5. 创建项目目录
echo ""
echo -e "${BLUE}📁 创建项目目录...${NC}"
mkdir -p "$(dirname "$PROJECT_DIR")"
if [ -d "$PROJECT_DIR" ]; then
    echo -e "${YELLOW}⚠️  项目目录已存在，将跳过克隆步骤${NC}"
else
    echo -e "${BLUE}📥 克隆项目代码...${NC}"
    cd "$(dirname "$PROJECT_DIR")"
    git clone git@github.com:ouhaibo1980/my-pansou.git pansou
    cd "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

# 6. 安装前端
echo ""
echo -e "${BLUE}🔧 安装前端...${NC}"
cd frontend
echo "   - 安装依赖..."
pnpm install --silent
echo "   - 构建前端..."
pnpm build --silent
echo -e "${GREEN}✅ 前端安装完成${NC}"

# 7. 安装后端
echo ""
echo -e "${BLUE}🔧 安装后端...${NC}"
cd ..
echo "   - 下载 Go 依赖..."
go mod download
echo "   - 编译后端..."
go build -o pansou main.go
echo -e "${GREEN}✅ 后端安装完成${NC}"

# 8. 启动服务
echo ""
echo -e "${BLUE}🚀 启动服务...${NC}"

# 停止旧进程（如果存在）
pm2 delete pansou-frontend 2>/dev/null || true
pm2 delete pansou-backend 2>/dev/null || true

# 启动前端
echo "   - 启动前端..."
cd frontend
pm2 start npm --name "pansou-frontend" -- start

# 启动后端
echo "   - 启动后端..."
cd ..
pm2 start ./pansou --name "pansou-backend"

# 设置开机自启
pm2 save

echo -e "${GREEN}✅ 服务已启动${NC}"

# 9. 配置 Nginx（如果是宝塔）
if [ "$BT_INSTALLED" = true ]; then
    echo ""
    echo -e "${BLUE}⚙️  配置 Nginx...${NC}"
    echo -e "${YELLOW}   请手动在宝塔面板中配置 Nginx 反向代理${NC}"
    echo -e "${YELLOW}   配置文件路径：/www/server/panel/vhost/nginx/你的域名.conf${NC}"
    echo ""
    echo "   前端代理配置："
    echo "   ```nginx"
    echo "   location / {"
    echo "       proxy_pass http://127.0.0.1:3000;"
    echo "       proxy_set_header Host \$host;"
    echo "       proxy_set_header X-Real-IP \$remote_addr;"
    echo "       proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;"
    echo "   }"
    echo "   ```"
    echo ""
    echo "   后端 API 代理配置："
    echo "   ```nginx"
    echo "   location /api {"
    echo "       proxy_pass http://127.0.0.1:8888;"
    echo "       proxy_set_header Host \$host;"
    echo "       proxy_set_header X-Real-IP \$remote_addr;"
    echo "       proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;"
    echo "   }"
    echo "   ```"
fi

# 10. 输出安装结果
echo ""
echo "=========================================="
echo -e "${GREEN}✅ 安装完成！${NC}"
echo "=========================================="
echo ""
echo "📱 访问地址："
echo "   - 本地访问: http://localhost:${FRONTEND_PORT}"
echo "   - API 服务: http://localhost:${BACKEND_PORT}/api"
echo ""
echo "🔧 管理命令："
echo "   查看状态: pm2 list"
echo "   查看日志: pm2 logs"
echo "   重启服务: pm2 restart all"
echo "   停止服务: pm2 stop all"
echo ""
echo "📁 项目目录: ${PROJECT_DIR}"
echo ""
echo "=========================================="
