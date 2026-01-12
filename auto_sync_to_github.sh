#!/bin/bash

# 自动同步到 GitHub 脚本
# 使用方式：./auto_sync_to_github.sh "commit message"
# 或者直接执行（使用默认提交信息）：./auto_sync_to_github.sh

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 获取提交信息（如果没有提供，使用默认信息）
COMMIT_MESSAGE="${1:-Auto sync: $(date '+%Y-%m-%d %H:%M:%S')}"

echo "=========================================="
echo "自动同步到 GitHub"
echo "=========================================="

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ 错误：当前目录不是 Git 仓库${NC}"
    exit 1
fi

# 拉取远程最新代码
echo ""
echo -e "${BLUE}📥 拉取远程最新代码...${NC}"
git pull origin main --rebase

# 添加所有文件
echo -e "${BLUE}📝 添加文件到暂存区...${NC}"
git add .

# 检查是否有变更
if git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️  没有需要提交的变更${NC}"
    exit 0
fi

# 提交变更
echo -e "${BLUE}📝 提交变更...${NC}"
git commit -m "$COMMIT_MESSAGE"

# 推送到远程仓库
echo -e "${BLUE}🚀 推送到远程仓库...${NC}"
git push origin main

echo ""
echo "=========================================="
echo -e "${GREEN}✅ 同步成功！${NC}"
echo "=========================================="
