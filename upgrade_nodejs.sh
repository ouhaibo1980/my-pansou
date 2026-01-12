#!/bin/bash

# 快速升级 Node.js 到 18.20.4 的脚本
# 使用方式：sudo ./upgrade_nodejs.sh

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 固定 Node.js 版本
NODE_VERSION_FULL="16.20.2"

echo "=========================================="
echo "Node.js 快速升级工具（统一版本：16.20.2）"
echo "=========================================="
echo ""

# 检查当前版本
CURRENT_VERSION=$(node -v 2>/dev/null || echo "未安装")
echo -e "${BLUE}当前 Node.js 版本: $CURRENT_VERSION${NC}"
echo ""

# 检测 Node.js 安装方式
if [ -f /usr/bin/node ] && [ -L /usr/bin/node ]; then
    INSTALL_TYPE="symbolic_link"
elif command -v apt-get &> /dev/null && dpkg -l | grep -q nodejs; then
    INSTALL_TYPE="apt"
elif command -v yum &> /dev/null && rpm -qa | grep -q nodejs; then
    INSTALL_TYPE="yum"
elif [ -f /usr/local/bin/node ]; then
    INSTALL_TYPE="binary"
elif command -v nvm &> /dev/null; then
    INSTALL_TYPE="nvm"
else
    INSTALL_TYPE="unknown"
fi

echo -e "${BLUE}检测到安装方式: $INSTALL_TYPE${NC}"
echo ""

# 检测 Linux 发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    OS_VERSION=$VERSION_ID
else
    OS=$(uname -s)
fi

echo -e "${BLUE}检测到系统: $OS${NC}"
echo ""

# 询问确认
echo -e "${YELLOW}⚠️  即将卸载当前的 Node.js $CURRENT_VERSION 并安装 Node.js ${NODE_VERSION_FULL}${NC}"
echo ""
read -p "确定要继续吗？(yes/no): " confirm

if [ "$confirm" != "yes" ] && [ "$confirm" != "y" ]; then
    echo -e "${YELLOW}❌ 已取消${NC}"
    exit 0
fi

# 卸载旧版本
echo ""
echo -e "${BLUE}🗑️  卸载旧版本 Node.js...${NC}"

case $INSTALL_TYPE in
    apt)
        apt-get remove -y nodejs
        apt-get autoremove -y
        ;;
    yum)
        yum remove -y nodejs
        yum autoremove -y
        ;;
    binary|symbolic_link)
        rm -f /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx
        rm -f /usr/bin/node /usr/bin/npm /usr/bin/npx
        rm -rf /usr/local/lib/node_modules
        ;;
    nvm)
        nvm uninstall 18 2>/dev/null || true
        nvm uninstall 16 2>/dev/null || true
        ;;
    *)
        rm -f /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx
        rm -f /usr/bin/node /usr/bin/npm /usr/bin/npx
        ;;
esac

echo -e "${GREEN}✅ 旧版本已卸载${NC}"

# 安装 Node.js 18.20.4
echo ""
echo -e "${BLUE}📦 安装 Node.js ${NODE_VERSION_FULL}...${NC}"

case $OS in
    ubuntu|debian|centos|rhel|rocky|almalinux|opencloudos|anolis|kylin)
        echo "   - 使用官方二进制包安装 Node.js ${NODE_VERSION_FULL}..."
        # 检测系统架构
        ARCH=$(uname -m)
        if [ "$ARCH" = "x86_64" ]; then
            NODE_ARCH="x64"
        elif [ "$ARCH" = "aarch64" ]; then
            NODE_ARCH="arm64"
        else
            NODE_ARCH="x64"
        fi

        # 下载 Node.js 二进制包
        NODE_TARBALL="node-v${NODE_VERSION_FULL}-linux-${NODE_ARCH}.tar.xz"

        echo "   - 正在下载 Node.js ${NODE_VERSION_FULL}..."
        if ! wget -O /tmp/${NODE_TARBALL} https://nodejs.org/dist/v${NODE_VERSION_FULL}/${NODE_TARBALL} --timeout=30; then
            echo "   - 官方源下载失败，尝试从国内镜像下载..."
            # 尝试从腾讯云镜像下载
            wget -O /tmp/${NODE_TARBALL} https://mirrors.cloud.tencent.com/nodejs-release/v${NODE_VERSION_FULL}/${NODE_TARBALL} || \
            # 尝试从阿里云镜像下载
            wget -O /tmp/${NODE_TARBALL} https://mirrors.aliyun.com/nodejs-release/v${NODE_VERSION_FULL}/${NODE_TARBALL} || {
                echo -e "${RED}❌ Node.js 下载失败${NC}"
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
        echo "   - 使用官方二进制包安装 Node.js ${NODE_VERSION_FULL}..."
        # 检测系统架构
        ARCH=$(uname -m)
        if [ "$ARCH" = "x86_64" ]; then
            NODE_ARCH="x64"
        elif [ "$ARCH" = "aarch64" ]; then
            NODE_ARCH="arm64"
        else
            NODE_ARCH="x64"
        fi

        # 下载 Node.js 二进制包
        NODE_TARBALL="node-v${NODE_VERSION_FULL}-linux-${NODE_ARCH}.tar.xz"

        echo "   - 正在下载 Node.js ${NODE_VERSION_FULL}..."
        if ! wget -O /tmp/${NODE_TARBALL} https://nodejs.org/dist/v${NODE_VERSION_FULL}/${NODE_TARBALL} --timeout=30; then
            echo "   - 官方源下载失败，尝试从国内镜像下载..."
            wget -O /tmp/${NODE_TARBALL} https://mirrors.cloud.tencent.com/nodejs-release/v${NODE_VERSION_FULL}/${NODE_TARBALL} || \
            wget -O /tmp/${NODE_TARBALL} https://mirrors.aliyun.com/nodejs-release/v${NODE_VERSION_FULL}/${NODE_TARBALL} || {
                echo -e "${RED}❌ Node.js 下载失败${NC}"
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
esac

# 验证安装
echo ""
echo -e "${BLUE}🔍 验证安装...${NC}"
NEW_VERSION=$(node -v)
echo -e "${GREEN}✅ Node.js 已升级到: $NEW_VERSION${NC}"

if [ "$NEW_VERSION" != "v${NODE_VERSION_FULL}" ]; then
    echo -e "${YELLOW}⚠️  版本不一致，期望: v${NODE_VERSION_FULL}，实际: $NEW_VERSION${NC}"
fi

# 重新安装 PM2
echo ""
echo -e "${BLUE}📦 重新安装 PM2...${NC}"
npm install -g pm2
echo -e "${GREEN}✅ PM2 已重新安装${NC}"

# 重新安装 pnpm
echo ""
echo -e "${BLUE}📦 重新安装 pnpm...${NC}"
npm install -g pnpm
echo -e "${GREEN}✅ pnpm 已重新安装${NC}"

# 配置国内镜像源
echo ""
echo -e "${BLUE}⚙️  配置国内镜像源...${NC}"
npm config set registry https://registry.npmmirror.com
pnpm config set registry https://registry.npmmirror.com
echo -e "${GREEN}✅ 镜像源配置完成${NC}"

# 重新构建前端
echo ""
echo -e "${BLUE}🔧 重新构建前端...${NC}"
if [ -d "/www/wwwroot/pansou/frontend" ]; then
    cd /www/wwwroot/pansou/frontend
    echo "   - 清理旧的构建..."
    rm -rf .next node_modules
    echo "   - 安装依赖..."
    pnpm install
    echo "   - 构建前端..."
    pnpm build
    echo -e "${GREEN}✅ 前端构建完成${NC}"
else
    echo -e "${YELLOW}⚠️  未找到前端目录，跳过构建${NC}"
fi

# 重启服务
echo ""
echo -e "${BLUE}🔄 重启服务...${NC}"
if command -v pm2 &> /dev/null; then
    pm2 restart all 2>/dev/null || echo "   - 没有运行中的 PM2 进程"
    echo -e "${GREEN}✅ 服务已重启${NC}"
else
    echo -e "${YELLOW}⚠️  PM2 未安装${NC}"
fi

# 完成
echo ""
echo "=========================================="
echo -e "${GREEN}✅ 升级完成！${NC}"
echo "=========================================="
echo ""
echo "当前 Node.js 版本: $(node -v)"
echo ""
echo "如果服务未自动启动，请执行："
echo "  cd /www/wwwroot/pansou"
echo "  ./quick_start.sh"
echo ""
echo "=========================================="
