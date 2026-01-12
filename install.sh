#!/bin/bash

# 装歌盘搜 - 快速安装脚本
# 使用方式：./install.sh --name="项目名称" 或 ./install.sh ou="项目名称"

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认配置
DEFAULT_PROJECT_NAME="装歌盘搜"
PROJECT_DIR="/www/wwwroot/pansou"
FRONTEND_PORT=3000
BACKEND_PORT=8888

# 代理配置（通过环境变量设置）
HTTP_PROXY="${HTTP_PROXY:-}"
HTTPS_PROXY="${HTTPS_PROXY:-}"
ALL_PROXY="${ALL_PROXY:-}"

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
echo "$PROJECT_NAME - 快速安装脚本"
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

# 1.5 配置国内镜像源（解决网络问题）
echo ""
echo -e "${BLUE}⚙️  配置国内镜像源...${NC}"

# 配置 npm 使用淘宝镜像
echo "   - 配置 npm 淘宝镜像..."
if command -v npm &> /dev/null; then
    npm config set registry https://registry.npmmirror.com
fi

# 配置 pnpm 使用淘宝镜像
echo "   - 配置 pnpm 淘宝镜像..."
if command -v pnpm &> /dev/null; then
    pnpm config set registry https://registry.npmmirror.com
fi

# 配置 Go 使用国内代理
echo "   - 配置 Go 国内代理..."
export GOPROXY=https://goproxy.cn,direct
echo 'export GOPROXY=https://goproxy.cn,direct' >> /etc/profile

echo -e "${GREEN}✅ 镜像源配置完成${NC}"

# 2. 检测并安装 Node.js 和 PM2
echo ""
echo -e "${BLUE}📦 检测 Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠️  未检测到 Node.js，正在安装...${NC}"

    # 检测 Linux 发行版
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        OS=$(uname -s)
    fi

    echo "   - 检测到系统: $OS"

    case $OS in
        ubuntu|debian)
            echo "   - 使用 NodeSource 安装 Node.js 20.x..."
            curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
            apt-get install -y nodejs
            ;;
        centos|rhel|rocky|almalinux)
            echo "   - 使用 NodeSource 安装 Node.js 20.x..."
            curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
            yum install -y nodejs
            ;;
        opencloudos|anolis|kylin)
            echo "   - 使用官方二进制包安装 Node.js 20.x..."
            # 检测系统架构
            ARCH=$(uname -m)
            if [ "$ARCH" = "x86_64" ]; then
                NODE_ARCH="x64"
            elif [ "$ARCH" = "aarch64" ]; then
                NODE_ARCH="arm64"
            else
                NODE_ARCH="x64"
            fi

            # 下载 Node.js 20.x 二进制包
            NODE_VERSION="20.18.0"
            NODE_TARBALL="node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz"

            echo "   - 正在下载 Node.js ${NODE_VERSION}..."
            if ! wget -O /tmp/${NODE_TARBALL} https://nodejs.org/dist/v${NODE_VERSION}/${NODE_TARBALL} --timeout=30; then
                echo "   - 官方源下载失败，尝试从国内镜像下载..."
                # 尝试从腾讯云镜像下载
                wget -O /tmp/${NODE_TARBALL} https://mirrors.cloud.tencent.com/nodejs-release/v${NODE_VERSION}/${NODE_TARBALL} || \
                # 尝试从阿里云镜像下载
                wget -O /tmp/${NODE_TARBALL} https://mirrors.aliyun.com/nodejs-release/v${NODE_VERSION}/${NODE_TARBALL} || {
                    echo -e "${RED}❌ Node.js 下载失败，请手动安装${NC}"
                    exit 1
                }
            fi

            # 解压并安装
            tar -xf /tmp/${NODE_TARBALL} -C /usr/local --strip-components=1
            ln -sf /usr/local/bin/node /usr/bin/node
            ln -sf /usr/local/bin/npm /usr/bin/npm
            ln -sf /usr/local/bin/npx /usr/bin/npx
            rm /tmp/${NODE_TARBALL}
            ;;
        *)
            echo "   - 使用通用方式安装 Node.js..."
            # 尝试使用 nvm 安装
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            nvm install 20
            nvm use 20
            nvm alias default 20
            ;;
    esac
fi

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js 安装失败，请手动安装${NC}"
    echo "   参考文档: https://nodejs.org/"
    exit 1
fi

echo -e "${GREEN}✅ Node.js 已安装 (版本: $(node -v))${NC}"

# 安装 PM2
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

    # 尝试从官方下载
    echo "   - 从官方源下载 Go..."
    if ! wget -O /tmp/go1.24.linux-amd64.tar.gz https://go.dev/dl/go1.24.0.linux-amd64.tar.gz --timeout=30; then
        echo "   - 官方源下载失败，尝试从国内镜像下载..."
        # 尝试从腾讯云镜像下载
        wget -O /tmp/go1.24.linux-amd64.tar.gz https://mirrors.cloud.tencent.com/golang/go1.24.0.linux-amd64.tar.gz --timeout=30 || \
        # 尝试从阿里云镜像下载
        wget -O /tmp/go1.24.linux-amd64.tar.gz https://mirrors.aliyun.com/golang/go1.24.0.linux-amd64.tar.gz || {
            echo -e "${RED}❌ Go 下载失败，请手动安装${NC}"
            exit 1
        }
    fi

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

    # 配置 Git 代理（如果设置了环境变量）
    if [ -n "$ALL_PROXY" ]; then
        echo -e "${YELLOW}   使用代理: $ALL_PROXY${NC}"
        export GIT_SSH_COMMAND="ssh -o ProxyCommand='nc -X 5 -x $ALL_PROXY %h %p'"
    elif [ -n "$HTTP_PROXY" ]; then
        echo -e "${YELLOW}   使用 HTTP 代理: $HTTP_PROXY${NC}"
        git config --global http.proxy "$HTTP_PROXY"
        git config --global https.proxy "$HTTP_PROXY"
    fi

    git clone https://github.com/ouhaibo1980/my-pansou.git pansou

    # 清除 Git 代理配置
    git config --global --unset http.proxy 2>/dev/null || true
    git config --global --unset https.proxy 2>/dev/null || true

    cd "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

# 5.5 生成前端配置
echo ""
echo -e "${BLUE}⚙️  生成前端配置...${NC}"
echo "   - 项目名称: $PROJECT_NAME"
cat > frontend/.env.local << EOF
NEXT_PUBLIC_APP_NAME=$PROJECT_NAME
EOF
echo -e "${GREEN}✅ 前端配置已生成${NC}"

# 6. 安装前端
echo ""
echo -e "${BLUE}🔧 安装前端...${NC}"
cd frontend

# 确保使用国内镜像源
pnpm config set registry https://registry.npmmirror.com

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

# 配置 Go 代理（国内用户推荐）
if [ -z "$GOPROXY" ]; then
    export GOPROXY=https://goproxy.cn,direct
    echo -e "${YELLOW}   使用 Go 代理: $GOPROXY${NC}"
fi

go mod download
echo "   - 编译后端..."
go build -o pansou main.go
echo -e "${GREEN}✅ 后端安装完成${NC}"

# 8. 启动服务
echo ""
echo -e "${BLUE}🚀 启动服务...${NC}"

# 停止旧进程（如果存在）
pm2 delete "${PROJECT_NAME}-frontend" 2>/dev/null || true
pm2 delete "${PROJECT_NAME}-backend" 2>/dev/null || true

# 启动前端
echo "   - 启动前端..."
cd frontend
pm2 start npm --name "${PROJECT_NAME}-frontend" -- start

# 启动后端
echo "   - 启动后端..."
cd ..
pm2 start ./pansou --name "${PROJECT_NAME}-backend"

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
