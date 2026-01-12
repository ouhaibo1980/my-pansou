# Docker 一键启动使用指南

## 快速开始

仅需 3 步，即可启动装歌盘搜服务：

```bash
# 1. 克隆仓库
git clone git@github.com:ouhaibo1980/my-pansou.git
cd my-pansou

# 2. 一键启动
./start_docker.sh

# 3. 访问应用
# 打开浏览器访问：http://localhost:5000
```

## 脚本说明

### start_docker.sh（推荐）

一键启动前端和后端服务，使用 Docker Compose 管理。

**功能：**
- 自动创建前端 Dockerfile
- 自动配置 docker-compose.yml
- 构建并启动所有容器
- 配置网络和数据卷

**使用方式：**
```bash
./start_docker.sh
```

**适用场景：**
- 完整部署（前端 + 后端）
- 需要数据持久化
- 需要容器编排管理

---

### start_with_docker.sh

直接使用 Docker 命令启动后端服务（仅 API）。

**功能：**
- 启动后端 API 服务
- 使用官方镜像
- 单容器部署

**使用方式：**
```bash
./start_with_docker.sh
```

**适用场景：**
- 仅需要 API 服务
- 快速测试
- 前端单独部署

---

### start_full_docker.sh

完整的 Docker 部署方案（包含前端和后端），不依赖 docker-compose。

**功能：**
- 分别启动前端和后端容器
- 自动健康检查
- 完整日志输出

**使用方式：**
```bash
./start_full_docker.sh
```

**适用场景：**
- 不使用 docker-compose
- 需要更细粒度的控制
- 学习和测试

---

### stop_docker.sh

停止所有 Docker 服务。

**使用方式：**
```bash
./stop_docker.sh
```

---

### restart_docker.sh

重启所有 Docker 服务。

**使用方式：**
```bash
./restart_docker.sh
```

## 管理命令

```bash
# 查看服务状态
docker-compose -p pansou ps

# 查看日志
docker-compose -p pansou logs -f

# 查看后端日志
docker logs -f pansou-backend

# 查看前端日志
docker logs -f pansou-frontend

# 进入后端容器
docker exec -it pansou-backend sh

# 进入前端容器
docker exec -it pansou-frontend sh
```

## 访问地址

- **Web 前端**: http://localhost:5000
- **API 服务**: http://localhost:8888/api
- **健康检查**: http://localhost:8888/api/health

## 端口配置

### 默认端口

- 前端：主机 5000 端口 → 容器 3000 端口
- 后端：主机 8888 端口 → 容器 8888 端口

### 修改端口

编辑 `docker-compose.yml`，修改 `ports` 配置：

```yaml
services:
  pansou-backend:
    ports:
      - "9999:8888"  # 修改后端端口为 9999

  pansou-frontend:
    ports:
      - "6000:3000"  # 修改前端端口为 6000
```

修改后重启服务：
```bash
./stop_docker.sh
./start_docker.sh
```

## 数据持久化

搜索结果缓存存储在 Docker 数据卷 `pansou-cache` 中，即使删除容器数据也不会丢失。

**查看数据卷：**
```bash
docker volume ls | grep pansou
```

**清理数据卷：**
```bash
docker volume rm pansou-cache
```

## 故障排查

### 端口冲突

如果端口被占用，修改 `docker-compose.yml` 中的端口配置。

### 容器启动失败

查看日志：
```bash
docker logs pansou-backend
docker logs pansou-frontend
```

### 无法访问

检查防火墙设置和端口是否正确映射：
```bash
docker-compose -p pansou ps
```

### Docker 未安装

访问 https://docs.docker.com/get-docker/ 安装 Docker。

### Docker Compose 未安装

Docker Desktop 已包含 Docker Compose，无需单独安装。
如果是 Linux 系统，访问 https://docs.docker.com/compose/install/ 安装。

## 常见问题

### Q: 首次启动需要多长时间？

A: 首次启动需要下载镜像和构建前端，大约需要 5-10 分钟。后续启动只需要几秒钟。

### Q: 如何更新服务？

A: 拉取最新代码并重启：
```bash
git pull
./restart_docker.sh
```

### Q: 如何卸载？

A: 停止服务并删除容器和数据卷：
```bash
./stop_docker.sh
docker volume rm pansou-cache
```

### Q: 可以同时运行多个实例吗？

A: 可以，修改 `PROJECT_NAME` 和端口配置即可。

## 系统要求

- Docker 20.10+
- Docker Compose 2.0+
- 至少 1GB 可用内存
- 至少 2GB 可用磁盘空间

## 技术支持

如遇问题，请：
1. 查看日志排查问题
2. 访问 GitHub Issues: https://github.com/ouhaibo1980/my-pansou/issues
