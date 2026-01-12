# 自动推送到 GitHub

本项目已配置自动推送脚本，方便你快速将代码推送到 GitHub 仓库。

## 快速开始

### 1. 创建 GitHub Personal Access Token

1. 访问：https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 勾选权限：
   - ✅ `repo` (完整的仓库访问权限)
4. 设置过期时间（建议选择 30 天或更长）
5. 点击 "Generate token"
6. ⚠️ **复制生成的 token**（只显示一次，请妥善保存）

### 2. 设置环境变量

在终端中运行：

```bash
export GITHUB_TOKEN="your_token_here"
```

将 `your_token_here` 替换为你刚刚复制的 token。

### 3. 运行推送脚本

```bash
chmod +x push_to_github.sh
./push_to_github.sh
```

## 自动化配置

### 方式 1：添加到 shell 配置文件（推荐）

将以下内容添加到 `~/.bashrc` 或 `~/.zshrc`：

```bash
export GITHUB_TOKEN="your_token_here"
cd /workspace/projects
alias push='./push_to_github.sh'
```

然后重新加载配置：

```bash
source ~/.bashrc
```

现在你可以直接运行 `push` 命令来推送代码。

### 方式 2：使用 Git credential helper

```bash
git config --global credential.helper store
echo "https://${GITHUB_TOKEN}@github.com" > ~/.git-credentials
```

这样配置后，之后推送就不需要再输入 token 了。

## 脚本功能说明

`push_to_github.sh` 脚本会自动完成以下操作：

1. ✅ 检查 GITHUB_TOKEN 是否配置
2. ✅ 自动配置远程仓库 URL（包含认证信息）
3. ✅ 检测并提交未提交的更改
4. ✅ 拉取远程仓库最新代码（避免冲突）
5. ✅ 推送代码到 GitHub

## 常见问题

### Q: Token 推送失败？

**A:** 检查以下几点：
- Token 是否正确复制（注意不要包含多余空格）
- Token 是否勾选了 `repo` 权限
- Token 是否已过期
- 仓库名称是否正确：`ouhaibo1980/my-pansou`

### Q: 如何保护 Token 安全？

**A:** 建议：
- ❌ 不要将 token 提交到 Git 仓库
- ✅ 使用环境变量或加密存储
- ✅ 定期更新 token
- ✅ 为 token 设置合理的过期时间

### Q: 如何推送到其他分支？

**A:** 修改脚本中的分支名称，或手动推送：

```bash
git push -u origin <branch_name>
```

## 一键配置（复制粘贴执行）

```bash
# 1. 设置你的 GitHub Token（替换下面的 your_token）
export GITHUB_TOKEN="your_token_here"

# 2. 添加推送脚本别名
echo 'alias push="./push_to_github.sh"' >> ~/.bashrc
source ~/.bashrc

# 3. 立即推送
./push_to_github.sh
```

## 安全提示

⚠️ **重要提醒：**
- Token 是敏感信息，请勿在公开场合分享
- 如怀疑 token 泄露，立即到 GitHub 设置中撤销并重新生成
- 建议定期（如每月）更新 token
