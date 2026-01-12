# 前后端集成版 Dockerfile
# 构建后端
FROM golang:1.24-alpine AS backend-builder

WORKDIR /app

# 安装构建依赖
RUN apk add --no-cache git ca-certificates

# 复制依赖文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 构建后端
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o pansou .

# 构建前端
FROM node:18-alpine AS frontend-builder

WORKDIR /app/frontend

# 复制前端依赖文件
COPY frontend/package*.json ./

# 安装依赖
RUN npm install

# 复制前端源代码
COPY frontend/ ./

# 构建前端
RUN npm run build

# 运行阶段
FROM alpine:3.19

# 安装运行时依赖
RUN apk add --no-cache ca-certificates tzdata nodejs npm

# 创建缓存目录
RUN mkdir -p /app/cache

# 从后端构建阶段复制二进制文件
COPY --from=backend-builder /app/pansou /app/pansou

# 从前端构建阶段复制构建产物
COPY --from=frontend-builder /app/frontend/.next /app/frontend/.next
COPY --from=frontend-builder /app/frontend/node_modules /app/frontend/node_modules
COPY --from=frontend-builder /app/frontend/package.json /app/frontend/package.json
COPY --from=frontend-builder /app/frontend/public /app/frontend/public

# 创建启动脚本
RUN cat > /app/start.sh << 'EOF'
#!/bin/sh
# 启动后端
/app/pansou &
BACKEND_PID=$!

# 等待后端启动
sleep 3

# 启动前端
cd /app/frontend
npm start &
FRONTEND_PID=$$

# 等待任意进程退出
wait $BACKEND_PID $FRONTEND_PID
EOF

RUN chmod +x /app/start.sh

WORKDIR /app

# 暴露端口
EXPOSE 5000

# 设置环境变量
ENV CACHE_PATH=/app/cache \
    CACHE_ENABLED=true \
    TZ=Asia/Shanghai

# 启动应用
CMD ["/app/start.sh"]
