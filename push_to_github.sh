#!/bin/bash

# 推送代码到 GitHub 脚本
# 使用方式：./push_to_github.sh "commit message"

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查是否提供了提交信息
if [ -z "$1" ]; then
    echo -e "${RED}❌ 错误：请提供提交信息${NC}"
    echo "   使用方式：./push_to_github.sh \"your commit message\""
    exit 1
fi

COMMIT_MESSAGE="$1"

echo "=========================================="
echo "推送到 GitHub"
echo "=========================================="

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ 错误：当前目录不是 Git 仓库${NC}"
    exit 1
fi

# 添加所有文件
echo ""
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
echo -e "${GREEN}✅ 推送成功！${NC}"
echo "=========================================="
