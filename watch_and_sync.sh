#!/bin/bash

# 文件监控并自动同步到 GitHub
# 使用方式：./watch_and_sync.sh

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=========================================="
echo "文件监控 - 自动同步到 GitHub"
echo "=========================================="

# 检查是否安装了 inotify-tools
if ! command -v inotifywait &> /dev/null; then
    echo -e "${RED}❌ 错误：未安装 inotify-tools${NC}"
    echo ""
    echo "请先安装 inotify-tools："
    echo "  Ubuntu/Debian: sudo apt-get install inotify-tools"
    echo "  CentOS/RHEL: sudo yum install inotify-tools"
    echo "  macOS: brew install fswatch"
    exit 1
fi

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ 错误：当前目录不是 Git 仓库${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 环境检查通过${NC}"
echo ""
echo -e "${BLUE}📡 开始监控文件变更...${NC}"
echo -e "${YELLOW}💡 提示：按 Ctrl+C 停止监控${NC}"
echo ""

# 监控文件变更
while true; do
    # 等待文件变更事件
    inotifywait -q -r -e modify,create,delete,move \
        --exclude '\.git|node_modules|\.next|cache|__pycache__|\.log' \
        . > /dev/null 2>&1

    # 等待 2 秒，避免频繁触发
    sleep 2

    # 检查是否有变更
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo ""
        echo -e "${BLUE}📝 检测到文件变更，开始同步...${NC}"
        echo ""

        # 执行同步
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

        # 拉取远程最新代码
        echo -e "${BLUE}📥 拉取远程最新代码...${NC}"
        git pull origin main --rebase

        # 添加所有文件
        git add .

        # 提交变更
        echo -e "${BLUE}📝 提交变更...${NC}"
        git commit -m "Auto sync: $TIMESTAMP"

        # 推送到远程仓库
        echo -e "${BLUE}🚀 推送到远程仓库...${NC}"
        git push origin main

        echo ""
        echo -e "${GREEN}✅ 同步成功！${NC}"
        echo ""
        echo -e "${BLUE}📡 继续监控...${NC}"
    fi
done
