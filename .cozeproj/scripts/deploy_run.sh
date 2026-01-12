#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

export ENV=production
export PORT=9999
export GOPROXY=https://goproxy.cn,direct

# 启用所有搜索源插件（77个）
export ENABLED_PLUGINS="ahhhhfs,aikanzy,alupan,ash,bixin,cldi,clmao,clxiong,cyg,daishudj,ddys,discourse,djgou,duoduo,dyyj,erxiao,feikuai,fox4k,gying,haisou,hdmoli,hdr4k,huban,hunhepan,javdb,jikepan,jsnoteclub,jutoushe,kkmao,kkv,labi,leijing,libvio,lou1,meitizy,miaoso,mikuclub,mizixing,muou,nsgame,nyaa,ouge,pan666,pansearch,panta,panwiki,panyq,pianku,qingying,qqpd,quark4k,quarksoo,qupanshe,qupansou,sdso,shandian,sousou,susu,thepiratebay,u3c3,wanou,weibo,wuji,xb6v,xdpan,xdyh,xiaoji,xiaozhang,xinjuc,xuexizhinan,xys,yiove,ypfxw,yuhuage,yunsou,zhizhen,zxzj"

# 停止现有进程
echo "Stopping existing services..." >&2
pkill -9 pansou 2>/dev/null || true
pkill -9 "next" 2>/dev/null || true
sleep 5

# 启动后端 API 服务
echo "Starting 装歌盘搜 API service on port 9999..." >&2
nohup ./pansou > /tmp/pansou.log 2>&1 &
BACKEND_PID=$!
sleep 8

# 检查后端进程是否还在运行
if ! kill -0 $BACKEND_PID 2>/dev/null; then
  echo "ERROR: 装歌盘搜 API service died unexpectedly" >&2
  cat /tmp/pansou.log >&2
  exit 1
fi

# 检查后端是否启动成功
if ! ss -tuln 2>/dev/null | grep -q 'LISTEN.*:9999'; then
  echo "ERROR: 装歌盘搜 API service is running but not listening on port 9999" >&2
  tail -30 /tmp/pansou.log >&2
  exit 1
fi

echo "✅ 装歌盘搜 API started on port 9999 (PID: $BACKEND_PID)" >&2

# 启动前端服务（前台运行，阻塞脚本退出）
echo "Starting frontend on port 5000..." >&2
cd frontend
node node_modules/next/dist/bin/next start -p 5000 > /tmp/frontend.log 2>&1 &
FRONTEND_PID=$!
cd ..

# 等待前端启动
echo "Waiting for frontend to start..." >&2
for i in {1..12}; do
  if ss -tuln 2>/dev/null | grep -q 'LISTEN.*:5000'; then
    echo "✅ Frontend started on port 5000 (PID: $FRONTEND_PID)" >&2
    echo "🚀 All services started successfully!" >&2
    echo "   Frontend: http://localhost:5000" >&2
    echo "   API: http://localhost:9999/api" >&2
    break
  fi
  echo "Waiting... ($i/12)" >&2
  sleep 1
done

if ! ss -tuln 2>/dev/null | grep -q 'LISTEN.*:5000'; then
  echo "ERROR: Failed to start frontend within 12 seconds" >&2
  tail -30 /tmp/frontend.log >&2
  exit 1
fi

# 阻塞等待前端进程，保持脚本运行
echo "✅ Service is running. Press Ctrl+C to stop." >&2
wait $FRONTEND_PID
