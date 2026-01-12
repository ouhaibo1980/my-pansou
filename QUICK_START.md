# 快速开始

## 使用 Docker 部署

### 方式一：使用 Docker Compose（推荐）

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

### 方式二：使用本地代码构建

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

## 环境变量

可以通过环境变量自定义配置：

```bash
docker run -d --name pansou \
  -p 5000:5000 \
  -e PORT=5000 \
  -e ENABLED_PLUGINS=ouge,labi,wanou \
  pansou-local
```

常用环境变量：
- `PORT`: 服务端口（默认 5000）
- `ENABLED_PLUGINS`: 启用的插件列表（逗号分隔）
- `CACHE_ENABLED`: 是否启用缓存（默认 true）
- `TZ`: 时区（默认 Asia/Shanghai）

## 访问地址

- **Web 前端**: http://localhost:5000
- **API 服务**: http://localhost:5000/api
- **健康检查**: http://localhost:5000/api/health

## 更多信息

- 完整文档：[README.md](README.md)
- Docker 详细指南：[DOCKER_GUIDE.md](DOCKER_GUIDE.md)
- GitHub 仓库：https://github.com/ouhaibo1980/my-pansou
