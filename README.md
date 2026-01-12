# 装歌盘搜

高性能网盘资源搜索引擎，提供美观的 Web 前端界面，支持 77 个搜索源插件。

## 快速开始

### 使用 Docker 部署

#### 克隆仓库并启动

```bash
# 克隆仓库
git clone git@github.com:ouhaibo1980/my-pansou.git
cd my-pansou

# 一键启动
./start_docker.sh
```

#### 或直接使用 Docker Compose

```bash
# 克隆仓库
git clone git@github.com:ouhaibo1980/my-pansou.git
cd my-pansou

# 启动服务
docker-compose up -d
```

启动后访问：http://localhost:5000

#### 管理命令

```bash
# 停止服务
./stop_docker.sh

# 重启服务
./restart_docker.sh

# 查看日志
docker-compose -p pansou logs -f

# 查看服务状态
docker-compose -p pansou ps
```

### 使用本地代码构建

```bash
# 克隆仓库
git clone git@github.com:ouhaibo1980/my-pansou.git
cd my-pansou

# 构建镜像
docker build -t pansou-local .

# 运行容器
docker run -d --name pansou -p 5000:5000 pansou-local
```

启动后访问：http://localhost:5000

## 功能特性

- 🚀 高性能并发搜索
- 🌐 支持 77 个搜索源插件（电影、音乐、软件、学习资源等）
- 💾 自动识别多种网盘类型（百度、阿里云、夸克、天翼云盘等）
- 🎨 美观的现代化 UI 界面
- ⚡ 智能结果排序（优化 ouge 插件优先级）
- 🔌 异步插件系统
- 💾 二级缓存机制
- 🔒 自动过滤失效链接
- 🐳 Docker 一键部署，开箱即用

## 访问地址

- **Web 前端**: http://localhost:5000
- **API 服务**: http://localhost:5000/api
- **健康检查**: http://localhost:5000/api/health

## 技术栈

### 前端
- Next.js 16 (App Router)
- React 19
- Tailwind CSS 4
- Lucide React (图标库)

### 后端
- Go 1.22
- Gin Web 框架

## API 接口

### 搜索接口
```
GET http://localhost:5000/api/search?keyword=搜索关键词
POST http://localhost:5000/api/search
Content-Type: application/json

{
  "keyword": "搜索关键词"
}
```

### 健康检查
```
GET http://localhost:5000/api/health
```

## 项目结构

```
.
├── frontend/          # Next.js 前端项目
│   ├── src/
│   │   └── app/
│   │       └── page.tsx    # 主页面
│   └── package.json
├── plugin/            # 77 个搜索源插件
├── pansou            # Go 后端二进制文件
├── cache/            # 缓存目录
├── Dockerfile        # Docker 镜像构建文件
├── docker-compose.yml  # Docker Compose 配置
├── start_docker.sh   # 一键启动脚本
├── stop_docker.sh    # 停止脚本
├── restart_docker.sh # 重启脚本
└── .coze            # 项目配置
```

## 环境变量

- `PORT`: 服务端口（默认 5000）
- `GOPROXY`: Go 模块代理
- `ENABLED_PLUGINS`: 启用的插件列表（77 个插件）

## 支持的网盘类型

百度网盘 (`baidu`)、阿里云盘 (`aliyun`)、夸克网盘 (`quark`)、天翼云盘 (`tianyi`)、UC网盘 (`uc`)、移动云盘 (`mobile`)、115网盘 (`115`)、PikPak (`pikpak`)、迅雷网盘 (`xunlei`)、123网盘 (`123`)、磁力链接 (`magnet`)、电驴链接 (`ed2k`)、其他 (`others`)

## 搜索结果示例

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total": 1420,
    "merged_by_type": {
      "aliyun": [
        {
          "url": "https://www.alipan.com/s/daARMGxX5RS",
          "password": "",
          "note": "青春猪头少年 系列 青春ブタ野郎 (2018-2026)",
          "datetime": "2026-01-10T20:17:43Z",
          "source": "plugin:susu"
        }
      ],
      "quark": [...],
      "baidu": [...]
    }
  }
}
```

## Docker 一键启动

项目提供了 Docker 一键启动方案，开箱即用，无需手动安装依赖。

### 前置要求

- Docker 已安装
- Docker Compose 已安装（Docker Desktop 自带）

### 一键启动

```bash
# 启动服务（前端 + 后端）
./start_docker.sh
```

脚本会自动：
- 配置 docker-compose.yml
- 构建并启动前端和后端容器
- 配置网络和数据卷

### 访问地址

- **Web 前端**: http://localhost:5000
- **API 服务**: http://localhost:5000/api
- **健康检查**: http://localhost:5000/api/health

### 管理命令

```bash
# 停止服务
./stop_docker.sh

# 重启服务
./restart_docker.sh

# 查看日志
docker-compose -p pansou logs -f

# 查看服务状态
docker-compose -p pansou ps
```

## 自动同步到 GitHub

项目提供了便捷的自动同步功能，将代码推送到 GitHub 仓库供他人部署。

### 方式一：手动触发同步

当你修改代码后，运行此脚本会自动检测变动并推送到 GitHub：

```bash
# 检测变动并自动同步
./auto_sync_to_github.sh
```

脚本会自动：
- 检测文件变动
- 添加所有更改
- 提交（带时间戳）
- 推送到 GitHub

### 方式二：后台自动监控（推荐）

启动守护进程后，每 10 秒自动检测变动并同步：

```bash
# 启动守护进程
./watch_and_sync.sh start

# 停止守护进程
./watch_and_sync.sh stop

# 查看运行状态
./watch_and_sync.sh status
```

**特点：**
- 完全自动化，无需手动操作
- 每 10 秒检测一次变动
- 日志记录同步历史：`/tmp/pansou_sync.log`

### GitHub 仓库

- **仓库地址**: https://github.com/ouhaibo1980/my-pansou
- **SSH URL**: git@github.com:ouhaibo1980/my-pansou.git

**注意**：首次使用需要配置 SSH 密钥并添加到 GitHub 账户。

## 原项目地址

- [PanSou](https://github.com/fish2018/pansou) - 网盘搜索 API
