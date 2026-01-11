#!/bin/bash

cd "${COZE_WORKSPACE_PATH}"

export ENV=production
export PORT=8888
export GOPROXY=https://goproxy.cn,direct

# 启用所有搜索源插件（77个）
export ENABLED_PLUGINS="ahhhhfs,aikanzy,alupan,ash,bixin,cldi,clmao,clxiong,cyg,daishudj,ddys,discourse,djgou,duoduo,dyyj,erxiao,feikuai,fox4k,gying,haisou,hdmoli,hdr4k,huban,hunhepan,javdb,jikepan,jsnoteclub,jutoushe,kkmao,kkv,labi,leijing,libvio,lou1,meitizy,miaoso,mikuclub,mizixing,muou,nsgame,nyaa,ouge,pan666,pansearch,panta,panwiki,panyq,pianku,qingying,qqpd,quark4k,quarksoo,qupanshe,qupansou,sdso,shandian,sousou,susu,thepiratebay,u3c3,wanou,weibo,wuji,xb6v,xdpan,xdyh,xiaoji,xiaozhang,xinjuc,xuexizhinan,xys,yiove,ypfxw,yuhuage,yunsou,zhizhen,zxzj"

# 停止现有进程
echo "Stopping existing services..."
pkill -9 pansou 2>/dev/null || true
pkill -9 "next" 2>/dev/null || true
sleep 5

# 启动后端 API 服务
echo "Starting PanSou API service on port 8888..."
nohup ./pansou > /tmp/pansou.log 2>&1 &
BACKEND_PID=$!
sleep 8

# 检查后端进程是否还在运行
if ! kill -0 $BACKEND_PID 2>/dev/null; then
  echo "ERROR: PanSou API service died unexpectedly"
  cat /tmp/pansou.log
  exit 1
fi

# 检查后端是否启动成功
if ! ss -tuln 2>/dev/null | grep -q 'LISTEN.*:8888'; then
  echo "ERROR: PanSou API service is running but not listening on port 8888"
  tail -30 /tmp/pansou.log
  exit 1
fi

echo "✅ PanSou API started on port 8888 (PID: $BACKEND_PID)"

# 启动前端服务
echo "Starting frontend on port 5000..."
cd frontend
nohup node node_modules/next/dist/bin/next start -p 5000 > /tmp/frontend.log 2>&1 &
cd ..

# 等待前端启动
sleep 10

if ! ss -tuln 2>/dev/null | grep -q 'LISTEN.*:5000'; then
  echo "ERROR: Failed to start frontend"
  tail -30 /tmp/frontend.log
  exit 1
fi

echo "✅ Frontend started on port 5000"
echo "🚀 All services started successfully!"
echo "   Frontend: http://localhost:5000"
echo "   API: http://localhost:8888/api"
