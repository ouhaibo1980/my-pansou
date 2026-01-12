#!/bin/bash

# 自动推送到 GitHub 脚本
# 使用方式：
# 1. 设置 GitHub Token 环境变量：export GITHUB_TOKEN="your_personal_access_token"
# 2. 运行脚本：./push_to_github.sh

set -e

echo "=========================================="
echo "🚀 开始推送到 GitHub"
echo "=========================================="

# 检查 GitHub Token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ 错误：未设置 GITHUB_TOKEN 环境变量"
    echo ""
    echo "请按以下步骤操作："
    echo "1. 访问：https://github.com/settings/tokens"
    echo "2. 点击 'Generate new token (classic)'"
    echo "3. 勾选 'repo' 权限"
    echo "4. 生成 token 并复制"
    echo "5. 设置环境变量："
    echo "   export GITHUB_TOKEN=\"your_token_here\""
    echo ""
    echo "然后重新运行此脚本"
    exit 1
fi

# 获取远程仓库 URL
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

# 如果远程仓库 URL 为空，添加远程仓库
if [ -z "$REMOTE_URL" ]; then
    echo "📌 添加远程仓库..."
    git remote add origin https://github.com/ouhaibo1980/my-pansou.git
    REMOTE_URL="https://github.com/ouhaibo1980/my-pansou.git"
fi

# 检查远程仓库 URL 是否包含 token
if [[ ! "$REMOTE_URL" =~ ^https://.*@github\.com/ ]]; then
    echo "🔧 配置远程仓库认证..."
    # 移除现有的远程仓库
    git remote remove origin
    # 添加带 token 的远程仓库 URL
    git remote add origin "https://${GITHUB_TOKEN}@github.com/ouhaibo1980/my-pansou.git"
    echo "✅ 远程仓库已配置"
fi

# 检查当前分支
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "📂 当前分支：$CURRENT_BRANCH"

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 检测到未提交的更改..."
    git add .
    git commit -m "Auto-commit from push script"
    echo "✅ 更改已提交"
fi

# 拉取最新代码（如果远程仓库已有内容）
echo "📥 拉取最新代码..."
git pull origin main --rebase 2>/dev/null || echo "  （首次推送，跳过拉取）"

# 推送代码
echo "📤 推送代码到 GitHub..."
git push -u origin main

echo ""
echo "=========================================="
echo "✅ 推送成功！"
echo "🔗 仓库地址：https://github.com/ouhaibo1980/my-pansou"
echo "=========================================="
