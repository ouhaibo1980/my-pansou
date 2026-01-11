#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

export ENV=production
export PORT=8888
export GOPROXY=https://goproxy.cn,direct

# 停止现有进程
pids=$(ss -lptn 'sport = :5000' 2>/dev/null | grep -o 'pid=[0-9]*' | cut -d= -f2)
[ -n "$pids" ] && kill -9 $pids 2>/dev/null
pids=$(ss -lptn 'sport = :8888' 2>/dev/null | grep -o 'pid=[0-9]*' | cut -d= -f2)
[ -n "$pids" ] && kill -9 $pids 2>/dev/null
sleep 2

# 启动后端 API 服务
echo "Starting PanSou API service on port 8888..."
nohup ./pansou > /tmp/pansou.log 2>&1 &
sleep 3

# 检查后端是否启动成功
if ! ss -tuln 2>/dev/null | grep -q ':8888.*LISTEN'; then
  echo "ERROR: Failed to start PanSou API service"
  tail -20 /tmp/pansou.log
  exit 1
fi

echo "✅ PanSou API started on port 8888"

# 启动前端服务
echo "Starting frontend on port 5000..."
cd frontend
nohup pnpm dev --port 5000 > /tmp/frontend.log 2>&1 &

# 等待前端启动
sleep 5

if ! ss -tuln 2>/dev/null | grep -q ':5000.*LISTEN'; then
  echo "ERROR: Failed to start frontend"
  tail -20 /tmp/frontend.log
  exit 1
fi

echo "✅ Frontend started on port 5000"
echo "🚀 All services started successfully!"
echo "   Frontend: http://localhost:5000"
echo "   API: http://localhost:8888/api"
