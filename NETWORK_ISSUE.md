

在执行安装脚本时，可能会遇到以下网络错误：

```
curl: (28) Failed to connect to cdn.jsdelivr.net port 443 after 135568 ms: Couldn't connect to server
```

## 问题原因

1. **网络问题**：国内服务器无法访问 cdn.jsdelivr.net
2. **npm/pnpm 默认源**：默认使用国外的 npm registry
3. **Go 默认代理**：Go 默认直接访问 golang.org 或 go.dev

## 解决方案（已自动配置）

从 v1.1 版本开始，install.sh 和 quick_start.sh 脚本已自动配置国内镜像源：

### 自动配置内容

1. **npm 镜像**：使用淘宝镜像 `https://registry.npmmirror.com`
2. **pnpm 镜像**：使用淘宝镜像 `https://registry.npmmirror.com`
3. **Go 代理**：使用 `https://goproxy.cn,direct`
4. **Go 下载源**：自动切换到腾讯云/阿里云镜像

### 安装脚本新增功能

```bash
# install.sh 自动配置
echo "   - 配置 npm 淘宝镜像..."
npm config set registry https://registry.npmmirror.com

echo "   - 配置 pnpm 淘宝镜像..."
pnpm config set registry https://registry.npmmirror.com

echo "   - 配置 Go 国内代理..."
export GOPROXY=https://goproxy.cn,direct

# Go 下载自动切换镜像源
wget -O /tmp/go1.24.linux-amd64.tar.gz https://mirrors.cloud.tencent.com/golang/go1.24.0.linux-amd64.tar.gz
```

## 手动配置方法（旧版本或特殊环境）

如果使用的是旧版本脚本，可以手动配置：

### 1. 配置 npm 镜像

```bash
# 临时配置
npm config set registry https://registry.npmmirror.com

# 验证配置
npm config get registry
```

### 2. 配置 pnpm 镜像

```bash
# 临时配置
pnpm config set registry https://registry.npmmirror.com

# 验证配置
pnpm config get registry
```

### 3. 配置 Go 代理

```bash
# 临时配置（当前会话）
export GOPROXY=https://goproxy.cn,direct

# 永久配置（写入 ~/.bashrc）
echo 'export GOPROXY=https://goproxy.cn,direct' >> ~/.bashrc
source ~/.bashrc

# 验证配置
echo $GOPROXY
```

### 4. 手动下载 Go（如果脚本下载失败）

```bash
# 从腾讯云镜像下载
wget -O /tmp/go1.24.linux-amd64.tar.gz https://mirrors.cloud.tencent.com/golang/go1.24.0.linux-amd64.tar.gz

# 或从阿里云镜像下载
wget -O /tmp/go1.24.linux-amd64.tar.gz https://mirrors.aliyun.com/golang/go1.24.0.linux-amd64.tar.gz

# 解压安装
tar -C /usr/local -xzf /tmp/go1.24.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
source /etc/profile
```

## 国内镜像源列表

### npm/pnpm 镜像

| 镜像名称 | 地址 |
|---------|------|
| 淘宝镜像（推荐） | https://registry.npmmirror.com |
| 腾讯云镜像 | https://mirrors.cloud.tencent.com/npm/ |
| 华为云镜像 | https://mirrors.huaweicloud.com/repository/npm/ |

### Go 代理

| 代理名称 | 地址 |
|---------|------|
| 七牛云（推荐） | https://goproxy.cn,direct |
| 阿里云 | https://mirrors.aliyun.com/goproxy/ |
| 腾讯云 | https://mirrors.cloud.tencent.com/go/ |

### Go 下载镜像

| 镜像名称 | 地址 |
|---------|------|
| 腾讯云 | https://mirrors.cloud.tencent.com/golang/ |
| 阿里云 | https://mirrors.aliyun.com/golang/ |

## 测试镜像源

```bash
# 测试 npm 镜像
curl -I https://registry.npmmirror.com

# 测试 Go 代理
curl -I https://goproxy.cn

# 测试 Go 下载镜像
curl -I https://mirrors.cloud.tencent.com/golang/go1.24.0.linux-amd64.tar.gz
```

## 其他网络问题

### 无法访问 GitHub

参考 README.md 中的"无法访问 GitHub 怎么办？"章节，使用 GitHub 代理。

### Git clone 失败

```bash
# 方法 1：使用 GitHub 代理
git clone https://gh.ddlc.top/https://github.com/ouhaibo1980/my-pansou.git

# 方法 2：配置 Git 代理
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
```

## 脚本版本说明

- **v1.1+**：自动配置国内镜像源，无需手动配置
- **v1.0**：需要手动配置镜像源

查看脚本版本：

```bash
# 查看安装脚本版本
head -20 install.sh | grep -i version

# 或查看 Git 提交历史
git log --oneline -5
```

## 更新脚本到最新版本

```bash
# 如果已安装，重新拉取最新脚本
cd /www/wwwroot/pansou
git pull origin main

# 或重新执行安装
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

## 常见错误信息

### 错误 2: next build --silent 选项不兼容

**错误信息：**
```
> frontend@0.1.0 build /www/wwwroot/pansou/frontend
> next build --silent

error: unknown option '--silent'
 ELIFECYCLE  Command failed with exit code 1.
```

**原因：**
- Next.js 15.x 不支持 `--silent` 选项
- 旧版本的 install.sh 使用了不兼容的构建命令

**解决方案：使用最新版本的 install.sh**

从 v1.2.2 版本开始，已修复此问题：

```bash
# 重新下载并执行最新版本
cd /www/wwwroot
rm -rf pansou
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**临时修复（手动执行）：**

如果已经克隆了代码，可以直接重新构建：

```bash
cd /www/wwwroot/pansou/frontend

# 清理旧的构建
rm -rf .next node_modules

# 重新安装依赖
pnpm install

# 重新构建（不使用 --silent）
pnpm build

# 重启服务
pm2 restart all
```

### 错误 1: OpenCloudOS/AnolisOS NodeSource 安装失败

# 验证安装
node -v  # 应该显示 v20.x.x
```

**解决方案 3：使用 nvm 管理版本**

```bash
# 安装 nvm（如果未安装）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc

# 安装并使用 Node.js 20.x
nvm install 20
nvm use 20
nvm alias default 20

# 验证
node -v
```

### 错误 1: OpenCloudOS/AnolisOS NodeSource 安装失败

**错误信息：**
```
2026-01-12 13:22:54 - Error: This script is intended for RPM-based systems. Please run it on an RPM-based system. (Exit Code: 1)
```

**原因**：
- NodeSource 的安装脚本无法正确识别 OpenCloudOS、AnolisOS、麒麟等国产 Linux 系统
- 这些系统虽然基于 RPM，但发行版标识与标准系统不同

**解决**：
最新版本的 install.sh（v1.1.2+）已修复此问题，改用以下方案：
- 直接下载 Node.js 18.x 官方二进制包
- 支持自动检测系统架构（x64/arm64）
- 自动切换到国内镜像源（腾讯云/阿里云）

### 错误 0: 不支持的指令 / npm: command not found

**错误信息：**
```
不支持的指令
===============================================
已取消!
⚠️  未检测到 PM2，正在安装...
bash: line 109: npm: command not found
```

**原因**：
- 宝塔面板的 `bt install pm2_manager` 命令在新版本中可能不兼容
- Node.js 安装失败，导致 npm 命令不存在

**解决**：
最新版本的 install.sh（v1.1.1+）已修复此问题，支持多种 Linux 发行版：
- Ubuntu / Debian
- CentOS / RHEL / Rocky Linux
- OpenCloudOS / AnolisOS / 麒麟系统

**手动修复**：
```bash
# Ubuntu/Debian 系统
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt-get install -y nodejs

# CentOS/RHEL/Rocky/OpenCloudOS 系统
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# 验证安装
node -v
npm -v

# 安装 PM2
npm install -g pm2

# 重新运行安装脚本
cd /www/wwwroot/pansou
sudo ./install.sh ou="装歌盘搜"
```

### 错误 1: npm ERR! network timeout

**原因**：npm 无法访问默认源

**解决**：脚本已自动配置淘宝镜像

### 错误 2: go: golang.org/x/...: unrecognized import path

**原因**：Go 无法访问 golang.org

**解决**：脚本已自动配置 goproxy.cn

### 错误 3: Connection refused

**原因**：网络完全无法访问外网

**解决**：使用本地代理或 VPN

## 联系支持

如果仍然遇到网络问题，请提供以下信息：

1. 错误信息的完整输出
2. 服务器所在地区
3. 是否可以使用代理
4. 测试镜像源的结果

```bash
# 收集诊断信息
echo "=== npm 配置 ==="
npm config get registry

echo "=== pnpm 配置 ==="
pnpm config get registry

echo "=== Go 代理配置 ==="
echo $GOPROXY

echo "=== 网络测试 ==="
curl -I https://registry.npmmirror.com
curl -I https://goproxy.cn
```
