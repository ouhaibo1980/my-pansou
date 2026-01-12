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
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
        --clean|-c)
            CLEAN_ALL=true
            shift
            ;;
        --help|-h)
            echo "使用方式: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  --name, -n      指定项目名称 (默认: 装歌盘搜)"
            echo "  --clean, -c     完全清理（包括 node_modules、编译文件等）"
            echo "  --help, -h      显示此帮助信息"
            echo ""
            echo "示例:"
            echo "  $0                    # 停止服务，保留文件"
            echo "  $0 --clean           # 停止服务并清理所有生成文件"
            exit 0
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
echo -e "${YELLOW}⚠️  此操作将执行以下步骤：${NC}"
echo "   1. 停止并删除 PM2 进程"
echo "   2. 移除 PM2 开机自启配置"

if [ "$CLEAN_ALL" = true ]; then
    echo -e "${RED}   3. 清理所有生成文件（node_modules、.next 等）${NC}"
    echo -e "${RED}   4. 删除编译的二进制文件（pansou）${NC}"
fi

echo ""
echo -e "${YELLOW}📍 项目目录: $SCRIPT_DIR${NC}"
echo ""

# 确认操作
read -p "确认继续？(y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}已取消卸载操作${NC}"
    exit 0
fi

# 1. 检查 PM2
echo ""
echo -e "${BLUE}🔍 检查 PM2...${NC}"

if ! command -v pm2 &> /dev/null; then
    echo -e "${YELLOW}⚠️  未检测到 PM2${NC}"
    echo "   跳过 PM2 进程清理"
else
    echo -e "${GREEN}✅ 检测到 PM2${NC}"

    # 2. 停止并删除后端进程
    echo ""
    echo -e "${BLUE}🛑 停止后端进程...${NC}"
    if pm2 list | grep -q "${PROJECT_NAME}-backend"; then
        pm2 stop "${PROJECT_NAME}-backend" 2>/dev/null || true
        pm2 delete "${PROJECT_NAME}-backend" 2>/dev/null || true
        echo -e "${GREEN}✅ 后端进程已停止并删除${NC}"
    else
        echo -e "${YELLOW}⚠️  后端进程不存在${NC}"
    fi

    # 3. 停止并删除前端进程
    echo ""
    echo -e "${BLUE}🛑 停止前端进程...${NC}"
    if pm2 list | grep -q "${PROJECT_NAME}-frontend"; then
        pm2 stop "${PROJECT_NAME}-frontend" 2>/dev/null || true
        pm2 delete "${PROJECT_NAME}-frontend" 2>/dev/null || true
        echo -e "${GREEN}✅ 前端进程已停止并删除${NC}"
    else
        echo -e "${YELLOW}⚠️  前端进程不存在${NC}"
    fi

    # 4. 保存 PM2 配置（移除已删除的进程）
    echo ""
    echo -e "${BLUE}💾 保存 PM2 配置...${NC}"
    pm2 save
    echo -e "${GREEN}✅ PM2 配置已更新${NC}"
fi

# 5. 清理生成文件（可选）
if [ "$CLEAN_ALL" = true ]; then
    echo ""
    echo -e "${BLUE}🧹 清理生成文件...${NC}"

    # 清理前端
    if [ -d "frontend" ]; then
        echo "   - 清理前端 node_modules..."
        rm -rf frontend/node_modules

        echo "   - 清理前端 .next 构建目录..."
        rm -rf frontend/.next

        echo "   - 清理前端 package-lock.json..."
        rm -f frontend/package-lock.json

        echo "   - 清理前端 pnpm-lock.yaml..."
        rm -f frontend/pnpm-lock.yaml

        echo -e "${GREEN}✅ 前端文件已清理${NC}"
    fi

    # 清理根目录
    echo "   - 清理根目录 node_modules..."
    rm -rf node_modules

    echo "   - 清理根目录 package-lock.json..."
    rm -f package-lock.json

    # 清理后端编译文件
    echo "   - 删除后端二进制文件..."
    rm -f pansou

    # 清理缓存文件（可选）
    echo "   - 清理缓存目录..."
    rm -rf cache

    echo -e "${GREEN}✅ 生成文件已清理${NC}"
fi

# 6. 输出完成信息
echo ""
echo "=========================================="
echo -e "${GREEN}✅ 卸载完成！${NC}"
echo "=========================================="
echo ""

if [ "$CLEAN_ALL" = true ]; then
    echo -e "${YELLOW}📝 已清理内容：${NC}"
    echo "   ✓ PM2 进程（前端和后端）"
    echo "   ✓ PM2 开机自启配置"
    echo "   ✓ node_modules 依赖目录"
    echo "   ✓ .next 构建文件"
    echo "   ✓ pansou 二进制文件"
    echo "   ✓ cache 缓存目录"
    echo ""
    echo -e "${GREEN}💡 项目源代码已保留，可重新运行 ./install.sh 安装${NC}"
else
    echo -e "${YELLOW}📝 已停止内容：${NC}"
    echo "   ✓ PM2 进程（前端和后端）"
    echo "   ✓ PM2 开机自启配置"
    echo ""
    echo -e "${GREEN}💡 项目文件已保留，可重新运行 ./quick_start.sh 启动${NC}"
fi

echo ""
echo "=========================================="
