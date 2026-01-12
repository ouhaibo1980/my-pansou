# 更新日志

## [1.2.1] - 2024-01-12

### 重要更新

- **实现智能 Node.js 版本选择**
- **兼容所有 Linux 系统（新系统用 20.x，旧系统用 18.x）**
- **添加 --node-version 参数支持手动选择**

### 新增功能

#### 🔍 智能版本选择

安装脚本现在会根据系统 glibc 版本自动选择最合适的 Node.js 版本：

**自动选择规则：**
| glibc 版本 | 系统示例 | 自动选择的 Node.js 版本 |
|-----------|---------|---------------------|
| >= 2.28 | Ubuntu 20.04+, Debian 11+, CentOS 8+, Rocky Linux, AlmaLinux | 20.x |
| 2.17 | CentOS 7, OpenCloudOS, 麒麟系统 | 18.x |

**使用示例：**
```bash
# 自动选择版本（推荐）
./install.sh ou="装歌盘搜"

# 手动指定 Node.js 18.x
./install.sh ou="装歌盘搜" --node-version=18

# 手动指定 Node.js 20.x
./install.sh ou="装歌盘搜" --node-version=20
```

### 改进

- **智能检测系统环境**：自动检测 glibc 版本
- **自动选择最优版本**：新系统用 Node.js 20.x（性能更好），旧系统用 Node.js 18.x（兼容性更好）
- **灵活的手动控制**：支持 --node-version 参数手动指定版本
- **兼容性大幅提升**：真正实现"所有系统要兼容"的目标

### 文档更新

- 更新 `README.md` - 添加"智能版本选择"章节
- 更新 `README.md` - 添加系统兼容性对比表
- 更新 `NETWORK_ISSUE.md` - 更新 glibc 版本不兼容的解决方案（使用智能版本选择）

### 技术细节

- glibc >= 2.28：Node.js 20.18.0（性能更好）
- glibc < 2.28：Node.js 18.20.4（兼容性更好）
- 自动检测系统架构（x64/arm64）
- 支持所有主流 Linux 发行版

## [1.2.0] - 2024-01-12

### 重要更新

- **降级 Next.js 到 15.0.4，兼容 Node.js >= 18.18.0**
- **兼容 CentOS 7 / OpenCloudOS / 麒麟系统（glibc 2.17）**
- **解决 glibc 版本不兼容导致的 Node.js 20.x 安装失败问题**

### 技术栈调整

#### 前端
- Next.js: 16.0.10 → 15.0.4
- React: 19.2.1 → 18.3.1
- @types/react: 19 → 18
- @types/react-dom: 19 → 18
- eslint-config-next: 16.0.10 → 15.0.4

#### 后端
- 保持不变：Go 1.24, Gin

### 改进

- **降级 Node.js 要求**：从 >= 20.9.0 降级到 >= 18.18.0
- **兼容旧系统**：支持 CentOS 7 等使用 glibc 2.17 的系统
- **自动选择版本**：install.sh 自动选择 Node.js 18.x（移除了 20.x 要求）
- **优化兼容性**：移除了对新系统特性的依赖

### 文档更新

- 更新 `README.md` - 添加"系统要求"章节，详细说明版本兼容性
- 更新 `README.md` - 更新技术栈说明（Next.js 15.0.4, React 18.3.1）
- 更新 `NETWORK_ISSUE.md` - 添加"错误 2: glibc 版本不兼容"详细说明
- 更新 `NETWORK_ISSUE.md` - 移除旧的 Node.js 版本升级说明
- 添加系统兼容性对比表

### Bug 修复

- 修复 CentOS 7 / OpenCloudOS / 麒麟系统无法安装的问题
- 修复 glibc 版本不兼容导致的 Node.js 20.x 安装失败
- 移除 upgrade_nodejs.sh 中的 Node.js 20.x 强制升级逻辑

### 重大变更

**注意**：如果你已安装 v1.1.x 版本，建议重新安装以获取兼容性更新：

```bash
# 卸载旧版本
cd /www/wwwroot
./pansou/uninstall.sh

# 重新安装（兼容 CentOS 7）
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

## [1.1.4] - 2024-01-12

### 重要更新

- **将 Node.js 版本从 18.x 升级到 20.x**
- **解决 Next.js 16 要求 Node.js >= 20.9.0 的版本兼容性问题**

### 改进

- 所有安装方式统一使用 Node.js 20.x
  - Ubuntu/Debian/CentOS/RHEL/Rocky/AlmaLinux: Node.js 20.x（NodeSource）
  - OpenCloudOS/AnolisOS/麒麟: Node.js 20.18.0（官方二进制包）
  - 其他系统: Node.js 20.x（nvm）

### 文档更新

- 更新 `NETWORK_ISSUE.md` - 添加错误 2（Node.js 版本不兼容）详细说明和解决方案

### Bug 修复

- 修复前端构建时 Node.js 版本不兼容错误
- 修复 `next build` 失败问题

## [1.1.3] - 2024-01-12

### 新增功能

#### 🗑️ 一键卸载脚本
- 新增 `uninstall.sh` 脚本，支持一键删除服务
- 支持停止并删除 PM2 进程（前端/后端）
- 支持删除项目目录
- 支持删除 PM2 配置（可选）
- 支持卸载依赖软件（可选）
- 支持卸载自定义名称实例
- 提供确认机制，避免误删

**使用示例：**
```bash
# 快速卸载
./uninstall.sh

# 卸载自定义名称实例
./uninstall.sh --name="我的网盘搜索"
./uninstall.sh ou="云盘搜"

# 使用 GitHub 代理下载卸载脚本
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/uninstall.sh -o uninstall.sh && chmod +x uninstall.sh && ./uninstall.sh
```

### 文档更新

- 更新 `README.md` - 添加"快速卸载脚本"章节

## [1.1.2] - 2024-01-12

### Bug 修复

- 修复 OpenCloudOS/AnolisOS/麒麟系统 Node.js 安装失败问题
- 改用官方二进制包方式安装 Node.js，避免 NodeSource 兼容性问题
- 支持自动检测系统架构（x64/arm64）
- 添加 Node.js 下载国内镜像源（腾讯云/阿里云）

### 改进

- 优化 OpenCloudOS、AnolisOS、麒麟等国产 Linux 系统的安装体验
- 提高安装脚本的兼容性和稳定性

## [1.1.1] - 2024-01-12

### Bug 修复

- 修复宝塔面板安装 Node.js 失败问题
- 移除不兼容的 `bt install pm2_manager` 命令
- 改用通用方式安装 Node.js，支持多种 Linux 发行版
- 将 GOPROXY 配置写入 `/etc/profile` 永久生效

### 新增支持

- ✅ Ubuntu / Debian 系统
- ✅ CentOS / RHEL / Rocky Linux
- ✅ OpenCloudOS / AnolisOS / 麒麟系统
- ✅ 自动检测 Linux 发行版并选择对应的安装方式

### 文档更新

- 更新 `README.md` - 添加"不支持的指令"错误解决方案
- 更新 `NETWORK_ISSUE.md` - 添加错误 0 详细说明和手动修复方法

## [1.1.0] - 2024-01-12

### 新增功能

#### 🎯 自定义项目名称
- 支持通过 `--name` 或 `ou` 参数自定义项目名称
- PM2 进程名称可自定义（如：`我的网盘搜-frontend`、`云盘搜-backend`）
- 前端页面标题和浏览器标签页标题可自定义
- 支持多实例部署，通过名称区分不同实例

**使用示例：**
```bash
# 使用 --name 参数
./install.sh --name="我的网盘搜索"

# 使用 ou 参数
./install.sh ou="云盘搜"
```

#### 🚀 Git 自动同步
- 配置 Git post-commit 钩子，每次提交后自动推送到 GitHub
- 简化开发流程，无需手动执行 `git push`
- 显示推送结果，成功或失败一目了然

#### 🌐 国内镜像源支持（自动配置）
- **npm**：自动配置淘宝镜像 `https://registry.npmmirror.com`
- **pnpm**：自动配置淘宝镜像 `https://registry.npmmirror.com`
- **Go**：自动配置七牛云代理 `https://goproxy.cn,direct`
- **Go 下载**：自动切换到腾讯云/阿里云镜像

**解决的问题：**
- ✅ 解决 `cdn.jsdelivr.net` 连接超时问题
- ✅ 解决 `golang.org` 无法访问问题
- ✅ 加速依赖下载速度

### 优化改进

- ✅ 优化 README 文档结构，突出核心功能
- ✅ 所有命令示例改为独立显示，更清晰易读
- ✅ 所有安装命令默认使用 `ou="装歌盘搜"` 参数
- ✅ GitHub 代理命令改为独立显示，共 4 个可选代理
- ✅ 添加详细的网络问题解决方案文档

### 文档更新

- 新增 `GIT_AUTO_SYNC.md` - Git 自动同步配置说明
- 新增 `NETWORK_ISSUE.md` - 网络问题详细解决方案
- 更新 `README.md` - 添加自定义项目名称章节
- 更新 `README.md` - 添加网络问题常见问题解答

### Bug 修复

- 修复宝塔面板安装时 `cdn.jsdelivr.net` 连接超时问题
- 修复 Go 下载失败时缺少备用下载源问题
- 修复前端构建时未使用国内镜像源问题

## [1.0.0] - 2024-01-10

### 初始版本

- ✅ 支持宝塔面板部署
- ✅ 支持一键安装脚本
- ✅ 支持快速启动脚本
- ✅ 支持 77 个搜索源插件
- ✅ Next.js 前端界面
- ✅ Go + Gin 后端 API
- ✅ PM2 进程管理
- ✅ Nginx 反向代理配置
- ✅ GitHub 代理支持

### 技术栈

**前端：**
- Next.js 16 (App Router)
- React 19
- Tailwind CSS 4
- Lucide React

**后端：**
- Go 1.24
- Gin Web 框架

**部署：**
- PM2 进程管理
- Nginx 反向代理
