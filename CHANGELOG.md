# 更新日志

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
