#!/bin/bash

# 自动同步脚本 - 检测变动并推送到 GitHub
# 使用方式：./auto_sync_to_github.sh

set -e

echo "=========================================="
echo "自动同步到 GitHub"
echo "=========================================="

# 配置
REMOTE_URL="git@github.com:ouhaibo1980/my-pansou.git"
COMMIT_MSG="Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"

# 配置远程仓库
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if [ "$CURRENT_REMOTE" != "$REMOTE_URL" ]; then
    if [ -z "$CURRENT_REMOTE" ]; then
        git remote add origin "$REMOTE_URL"
    else
        git remote set-url origin "$REMOTE_URL"
    fi
fi

# 检查是否有变动
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ 没有检测到文件变动，无需同步"
    exit 0
fi

echo "📝 检测到文件变动："
git status --short

# 添加所有更改
echo ""
echo "📦 添加更改..."
git add .

# 提交
echo "🔐 提交更改..."
git commit -m "$COMMIT_MSG"

# 推送
echo "📤 推送到 GitHub..."
git push origin main

echo ""
echo "=========================================="
echo "✅ 同步完成！"
echo "🔗 仓库：https://github.com/ouhaibo1980/my-pansou"
echo "=========================================="
