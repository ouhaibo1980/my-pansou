#!/bin/bash

# 推送到 GitHub 脚本
# 使用方式：./push_to_github.sh

set -e

echo "=========================================="
echo "开始推送到 GitHub"
echo "=========================================="

# 配置远程仓库 URL
REMOTE_URL="git@github.com:ouhaibo1980/my-pansou.git"

# 获取当前远程仓库 URL
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")

# 如果远程仓库 URL 不匹配，更新它
if [ "$CURRENT_REMOTE" != "$REMOTE_URL" ]; then
    if [ -z "$CURRENT_REMOTE" ]; then
        echo "添加远程仓库..."
        git remote add origin "$REMOTE_URL"
    else
        echo "更新远程仓库 URL..."
        git remote set-url origin "$REMOTE_URL"
    fi
fi

# 检查当前分支
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "当前分支：$CURRENT_BRANCH"

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo "检测到未提交的更改..."
    git add .
    read -p "请输入提交信息（默认：Auto-commit）: " COMMIT_MSG
    COMMIT_MSG=${COMMIT_MSG:-"Auto-commit"}
    git commit -m "$COMMIT_MSG"
    echo "更改已提交"
fi

# 推送代码
echo "推送代码到 GitHub..."
git push -u origin "$CURRENT_BRANCH"

echo ""
echo "=========================================="
echo "推送成功！"
echo "仓库地址：https://github.com/ouhaibo1980/my-pansou"
echo "=========================================="
