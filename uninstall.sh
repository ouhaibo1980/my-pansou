#!/bin/bash

# 装歌盘搜 - 一键卸载脚本
# 使用方式：./uninstall.sh

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
echo "$PROJECT_NAME - 一键卸载"
echo "=========================================="
echo ""

# 确认卸载
echo -e "${YELLOW}⚠️  即将卸载 $PROJECT_NAME${NC}"
echo ""
echo "卸载内容："
echo "  - 停止并删除 PM2 进程 (${PROJECT_NAME}-frontend, ${PROJECT_NAME}-backend)"
echo "  - 删除项目目录: $PROJECT_DIR"
echo ""
read -p "确定要继续吗？(yes/no): " confirm

if [ "$confirm" != "yes" ] && [ "$confirm" != "y" ]; then
    echo -e "${YELLOW}❌ 已取消卸载${NC}"
    exit 0
fi

# 1. 停止并删除 PM2 进程
echo ""
echo -e "${BLUE}🛑 停止 PM2 进程...${NC}"
if command -v pm2 &> /dev/null; then
    pm2 delete "${PROJECT_NAME}-frontend" 2>/dev/null || echo "   - 前端进程不存在"
    pm2 delete "${PROJECT_NAME}-backend" 2>/dev/null || echo "   - 后端进程不存在"
    echo -e "${GREEN}✅ PM2 进程已停止${NC}"
else
    echo -e "${YELLOW}⚠️  PM2 未安装，跳过${NC}"
fi

# 2. 删除项目目录
echo ""
echo -e "${BLUE}🗑️  删除项目目录...${NC}"
if [ -d "$PROJECT_DIR" ]; then
    echo "   - 正在删除: $PROJECT_DIR"
    rm -rf "$PROJECT_DIR"
    echo -e "${GREEN}✅ 项目目录已删除${NC}"
else
    echo -e "${YELLOW}⚠️  项目目录不存在: $PROJECT_DIR${NC}"
fi

# 3. 询问是否删除 PM2 配置
echo ""
read -p "是否删除 PM2 配置（包括开机自启设置）？(yes/no): " delete_pm2_config

if [ "$delete_pm2_config" = "yes" ] || [ "$delete_pm2_config" = "y" ]; then
    if command -v pm2 &> /dev/null; then
        echo -e "${BLUE}🗑️  删除 PM2 配置...${NC}"
        pm2 save --force 2>/dev/null || true
        pm2 flush 2>/dev/null || true
        echo -e "${GREEN}✅ PM2 配置已删除${NC}"
    else
        echo -e "${YELLOW}⚠️  PM2 未安装，跳过${NC}"
    fi
fi

# 4. 询问是否卸载依赖软件
echo ""
read -p "是否卸载安装的依赖软件（Node.js/Go/pnpm）？(yes/no): " uninstall_deps

if [ "$uninstall_deps" = "yes" ] || [ "$uninstall_deps" = "y" ]; then
    echo -e "${BLUE}🗑️  卸载依赖软件...${NC}"

    # 卸载 pnpm
    if command -v pnpm &> /dev/null; then
        echo "   - 卸载 pnpm..."
        npm uninstall -g pnpm 2>/dev/null || true
    fi

    # 卸载 PM2
    if command -v pm2 &> /dev/null; then
        echo "   - 卸载 PM2..."
        npm uninstall -g pm2 2>/dev/null || true
    fi

    # 卸载 Node.js（通过包管理器）
    echo "   - 卸载 Node.js（需要手动执行）"
    echo "     Ubuntu/Debian: apt-get remove -y nodejs"
    echo "     CentOS/RHEL: yum remove -y nodejs"
    echo "     手动安装: rm -rf /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx"

    # 卸载 Go（手动）
    echo "   - 卸载 Go（需要手动执行）"
    echo "     rm -rf /usr/local/go"

    echo -e "${GREEN}✅ 部分依赖已卸载${NC}"
    echo -e "${YELLOW}⚠️  Node.js 和 Go 需要手动卸载${NC}"
fi

# 完成
echo ""
echo "=========================================="
echo -e "${GREEN}✅ 卸载完成！${NC}"
echo "=========================================="
echo ""
echo "如果需要完全清理，请手动执行以下命令："
echo ""
echo "  # 卸载 Node.js（二进制方式安装）"
echo "  sudo rm -rf /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx"
echo ""
echo "  # 卸载 Go"
echo "  sudo rm -rf /usr/local/go"
echo ""
echo "  # 卸载 PM2 完全（包括配置）"
echo "  rm -rf ~/.pm2"
echo ""
echo "=========================================="
