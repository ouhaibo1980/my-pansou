# 使用 SSH 推送到 GitHub

本项目已配置 SSH key，可以使用 SSH 方式安全地推送代码到 GitHub。

## SSH Key 信息

**公钥内容**（需要添加到 GitHub）：

```ssh
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3Kjs2AfSTlxKevw0CpC1ODA1W/rnjgG2I8xRvMWwEO pansou@ouge
```

**指纹**：`SHA256:D0AQamsdUasir3A/PuKNRhCtlYS3ftIcjXLUcl5WJcI`

## 添加 SSH Key 到 GitHub

### 步骤 1：复制公钥

点击上方公钥框的"复制"按钮，或复制以下内容：

```bash
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3Kjs2AfSTlxKevw0CpC1ODA1W/rnjgG2I8xRvMWwEO pansou@ouge
```

### 步骤 2：添加到 GitHub

1. 访问：https://github.com/settings/keys
2. 点击 **"New SSH key"** 按钮
3. 填写信息：
   - **Title**: `pansou-server` 或任意名称
   - **Key type**: 选择 `Authentication Key`
   - **Key**: 粘贴刚才复制的公钥
4. 点击 **"Add SSH key"**

### 步骤 3：验证 SSH 连接

```bash
ssh -T git@github.com
```

首次连接会提示：

```
The authenticity of host 'github.com (20.205.243.166)' can't be established.
ED25519 key fingerprint is SHA256:...
Are you sure you want to continue connecting (yes/no)?
```

输入 `yes` 即可。

如果成功，会看到：

```
Hi ouhaibo1980! You've successfully authenticated, but GitHub does not provide shell access.
```

## 推送代码到 GitHub

### 方式 1：直接推送

```bash
cd /workspace/projects
git push -u origin main
```

### 方式 2：使用推送脚本（已配置 SSH）

```bash
./push_to_github.sh
```

脚本会自动使用 SSH 方式推送。

## 查看已配置的远程仓库

```bash
git remote -v
```

应该看到：

```
origin  git@github.com:ouhaibo1980/my-pansou.git (fetch)
origin  git@github.com:ouhaibo1980/my-pansou.git (push)
```

## SSH 配置文件（可选）

创建 `~/.ssh/config` 文件，简化配置：

```bash
cat > ~/.ssh/config << EOF
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
EOF
```

## 常见问题

### Q: 推送时提示 "Permission denied (publickey)"

**A:** 检查以下几点：
- SSH key 是否正确添加到 GitHub
- 是否使用了正确的用户名：`ouhaibo1980`
- 仓库名称是否正确：`my-pansou`

### Q: 如何确认 SSH key 已添加？

**A:**
1. 访问：https://github.com/settings/keys
2. 查看列表中是否有刚才添加的 key
3. 可以在 "Title" 列中看到 "pansou-server"

### Q: 如何生成新的 SSH key？

**A:** 如果需要更换 SSH key：

```bash
# 删除旧的
rm -f ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub

# 生成新的
ssh-keygen -t ed25519 -C "pansou@ouge" -f ~/.ssh/id_ed25519 -N ""

# 显示新公钥
cat ~/.ssh/id_ed25519.pub
```

然后将新公钥添加到 GitHub。

## 安全建议

✅ **推荐做法**：
- 定期检查 GitHub 上的 SSH key 列表
- 如果发现不认识的 key，立即删除
- 不要泄露私钥 (`~/.ssh/id_ed25519`)
- 私钥文件权限应为 `600`

❌ **禁止做法**：
- 不要将私钥分享给他人
- 不要将私钥提交到代码仓库
- 不要在不安全的网络中使用 SSH

## 一键推送（配置 SSH Key 后）

```bash
# 1. 将公钥添加到 GitHub（见上方步骤）
# 2. 测试连接
ssh -T git@github.com

# 3. 推送代码
git push -u origin main
```

## 自动化推送配置

添加到 `~/.bashrc`：

```bash
echo 'alias push="cd /workspace/projects && git push"' >> ~/.bashrc
source ~/.bashrc
```

之后只需运行：

```bash
push
```

## 当前项目状态

- ✅ SSH key 已生成：`~/.ssh/id_ed25519`
- ✅ 远程仓库已配置为 SSH URL
- ✅ 代码已提交到本地 Git 仓库
- ⏳ 等待添加 SSH key 到 GitHub 后推送

## 添加 SSH Key 完成后

执行以下命令推送代码：

```bash
cd /workspace/projects
git push -u origin main
```

或者使用脚本：

```bash
./push_to_github.sh
```
