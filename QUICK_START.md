# 快速开始

装歌盘搜提供多种 Docker 部署方式，开箱即用。

## 说明

- `ghcr.io/fish2018/pansou:latest` - 官方后端镜像（仅 API）
- 本地构建镜像 - 包含前端和后端的完整版本（推荐）

## 前后端集成版

### 直接使用 Docker 命令

一键启动，开箱即用：

```bash
docker run -d --name pansou \
  -p 5000:5000 \
  ghcr.io/fish2018/pansou:latest
```

**注意**：此命令仅启动后端 API 服务，如需完整的前端界面，请使用 Docker Compose 方式。

### 使用 Docker Compose（推荐）

#### 下载配置文件

```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/docker-compose.simple.yml
```

#### 一键启动

```bash
docker-compose up -d
```

启动后访问 API 服务：http://localhost:8888/api

**注意**：此配置仅启动后端 API 服务。如需完整的前端界面，请使用本地构建方式。

#### 管理命令

```bash
# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看日志
docker-compose logs -f
```

## 分离部署版本

### 仅后端 API

```bash
docker run -d --name pansou-backend \
  -p 8888:8888 \
  ghcr.io/fish2018/pansou:latest
```

### 使用本地代码构建

如果你已经克隆了仓库，可以使用本地代码构建前后端集成版：

```bash
# 克隆仓库
git clone git@github.com:ouhaibo1980/my-pansou.git
cd my-pansou

# 构建镜像（包含前端和后端）
docker build -t pansou-local .

# 运行容器
docker run -d --name pansou -p 5000:5000 pansou-local
```

启动后访问：http://localhost:5000

## 环境变量

可以通过环境变量自定义配置：

```bash
docker run -d --name pansou \
  -p 5000:5000 \
  -e PORT=5000 \
  -e ENABLED_PLUGINS=ouge,labi,wanou \
  ghcr.io/fish2018/pansou:latest
```

常用环境变量：
- `PORT`: 服务端口（默认 5000）
- `ENABLED_PLUGINS`: 启用的插件列表（逗号分隔）
- `CACHE_ENABLED`: 是否启用缓存（默认 true）
- `TZ`: 时区（默认 Asia/Shanghai）

## 完整版部署（前端 + 后端）

如果你需要完整的前后端集成界面，请使用本地构建：

```bash
# 克隆仓库
git clone git@github.com:ouhaibo1980/my-pansou.git
cd my-pansou

# 一键启动
./start_docker.sh
```

启动后访问：http://localhost:5000

## 更多信息

- 完整文档：[README.md](README.md)
- Docker 详细指南：[DOCKER_GUIDE.md](DOCKER_GUIDE.md)
- GitHub 仓库：https://github.com/ouhaibo1980/my-pansou
