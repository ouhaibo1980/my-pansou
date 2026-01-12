#!/bin/bash

# 守护进程 - 持续监控文件变动并自动同步
# 使用方式：
#   启动守护：./watch_and_sync.sh start
#   停止守护：./watch_and_sync.sh stop
#   查看状态：./watch_and_sync.sh status

PID_FILE="/tmp/pansou_sync.pid"
LOG_FILE="/tmp/pansou_sync.log"

start_daemon() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "❌ 守护进程已在运行中 (PID: $(cat $PID_FILE))"
        exit 1
    fi

    echo "🚀 启动文件变动监控守护进程..."
    echo "   检测到变动将自动提交并推送到 GitHub"
    echo "   日志文件：$LOG_FILE"
    echo ""

    nohup bash -c '
        while true; do
            sleep 10
            if [ -n "$(git status --porcelain)" ]; then
                echo "[$(date "+%Y-%m-%d %H:%M:%S")] 检测到变动，开始同步..." >> "'"$LOG_FILE"'"
                git add . || true
                git commit -m "Auto-sync: $(date "+%Y-%m-%d %H:%M:%S")" >> "'"$LOG_FILE"'" 2>&1 || true
                git push origin main >> "'"$LOG_FILE"'" 2>&1 || true
                echo "[$(date "+%Y-%m-%d %H:%M:%S")] 同步完成" >> "'"$LOG_FILE"'"
            fi
        done
    ' > /dev/null 2>&1 &

    echo $! > "$PID_FILE"
    echo "✅ 守护进程已启动 (PID: $(cat $PID_FILE))"
    echo "   使用 ./watch_and_sync.sh stop 可以停止"
}

stop_daemon() {
    if [ ! -f "$PID_FILE" ]; then
        echo "❌ 守护进程未运行"
        exit 1
    fi

    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm "$PID_FILE"
        echo "✅ 守护进程已停止 (PID: $PID)"
    else
        rm "$PID_FILE"
        echo "⚠️  守护进程进程不存在"
    fi
}

show_status() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "✅ 守护进程运行中 (PID: $(cat $PID_FILE))"
        echo ""
        echo "最近的同步记录："
        tail -10 "$LOG_FILE" 2>/dev/null || echo "（暂无日志）"
    else
        echo "❌ 守护进程未运行"
    fi
}

case "$1" in
    start)
        start_daemon
        ;;
    stop)
        stop_daemon
        ;;
    status)
        show_status
        ;;
    *)
        echo "使用方式："
        echo "  $0 start   - 启动守护进程"
        echo "  $0 stop    - 停止守护进程"
        echo "  $0 status  - 查看运行状态"
        exit 1
        ;;
esac
