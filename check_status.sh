#!/bin/bash

# 装歌盘搜 - 服务状态检查脚本
# 使用方式：./check_status.sh

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 默认配置
DEFAULT_PROJECT_NAME="装歌盘搜"

# 解析参数
for arg in "$@"; do
    case $arg in
        --name=*|-n=*)
            PROJECT_NAME="${arg#*=}"
            shift
            ;;
        ou=*)
            PROJECT_NAME="${arg#*=}"
            shift
            ;;
        *)
            ;;
    esac
done

PROJECT_NAME="${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}"

echo "=========================================="
echo "$PROJECT_NAME - 服务状态检查"
echo "=========================================="
echo ""

# 1. 检查 PM2 是否安装
echo -e "${BLUE}1️⃣  检查 PM2...${NC}"
if command -v pm2 &> /dev/null; then
    echo -e "${GREEN}✅ PM2 已安装 ($(pm2 --version))${NC}"
    PM2_AVAILABLE=true
else
    echo -e "${RED}❌ PM2 未安装${NC}"
    PM2_AVAILABLE=false
fi

# 2. 检查 PM2 进程
echo ""
echo -e "${BLUE}2️⃣  检查 PM2 进程...${NC}"
if [ "$PM2_AVAILABLE" = true ]; then
    echo ""
    pm2 list | grep -E "pm2|online|stopped|errored" || true
    echo ""

    # 检查前端进程
    if pm2 list | grep -q "${PROJECT_NAME}-frontend.*online"; then
        echo -e "${GREEN}✅ 前端进程运行中：${PROJECT_NAME}-frontend${NC}"
    else
        echo -e "${RED}❌ 前端进程未运行：${PROJECT_NAME}-frontend${NC}"
    fi

    # 检查后端进程
    if pm2 list | grep -q "${PROJECT_NAME}-backend.*online"; then
        echo -e "${GREEN}✅ 后端进程运行中：${PROJECT_NAME}-backend${NC}"
    else
        echo -e "${RED}❌ 后端进程未运行：${PROJECT_NAME}-backend${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  PM2 不可用，跳过进程检查${NC}"
fi

# 3. 检查端口监听
echo ""
echo -e "${BLUE}3️⃣  检查端口监听...${NC}"

# 检查 5000 端口（前端）
if ss -ltn 2>/dev/null | grep -q ':5000' || netstat -ltn 2>/dev/null | grep -q ':5000'; then
    FRONTEND_PID=$(ss -lptn 'sport = :5000' 2>/dev/null | grep -oP 'pid=\K[0-9]+' || echo "未知")
    echo -e "${GREEN}✅ 5000 端口（前端）正在监听 (PID: $FRONTEND_PID)${NC}"

    # 测试端口响应
    if curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:5000 | grep -q "200\|302\|307"; then
        echo -e "${GREEN}   前端响应正常${NC}"
    else
        echo -e "${YELLOW}   ⚠️  前端响应异常${NC}"
    fi
else
    echo -e "${RED}❌ 5000 端口（前端）未监听${NC}"
fi

# 检查 8888 端口（后端）
if ss -ltn 2>/dev/null | grep -q ':8888' || netstat -ltn 2>/dev/null | grep -q ':8888'; then
    BACKEND_PID=$(ss -lptn 'sport = :8888' 2>/dev/null | grep -oP 'pid=\K[0-9]+' || echo "未知")
    BACKEND_PROCESS=$(ps -p $BACKEND_PID -o comm= 2>/dev/null || echo "未知")

    echo -e "${GREEN}✅ 8888 端口（后端）正在监听 (PID: $BACKEND_PID, 进程: $BACKEND_PROCESS)${NC}"

    # 警告：宝塔面板默认端口
    if [ "$BACKEND_PROCESS" != "pansou" ]; then
        echo -e "${RED}   ⚠️  8888 端口被宝塔面板或其他进程占用！${NC}"
        echo -e "${YELLOW}   建议：修改后端端口避免冲突${NC}"
    fi

    # 测试 API 响应
    if curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8888/api/health | grep -q "200\|404"; then
        echo -e "${GREEN}   后端 API 响应正常${NC}"
    else
        echo -e "${YELLOW}   ⚠️  后端 API 响应异常${NC}"
    fi
else
    echo -e "${RED}❌ 8888 端口（后端）未监听${NC}"
fi

# 4. 检查防火墙
echo ""
echo -e "${BLUE}4️⃣  检查防火墙状态...${NC}"

# 检查 firewalld
if command -v firewall-cmd &> /dev/null && systemctl is-active --quiet firewalld; then
    echo -e "${YELLOW}🔥 firewalld 正在运行${NC}"
    if firewall-cmd --list-ports | grep -q '5000/tcp'; then
        echo -e "${GREEN}   5000/tcp 已放行${NC}"
    else
        echo -e "${YELLOW}   ⚠️  5000/tcp 未放行${NC}"
    fi
    if firewall-cmd --list-ports | grep -q '8888/tcp'; then
        echo -e "${GREEN}   8888/tcp 已放行${NC}"
    else
        echo -e "${YELLOW}   ⚠️  8888/tcp 未放行${NC}"
    fi
fi

# 检查 iptables
if command -v iptables &> /dev/null && iptables -L -n 2>/dev/null | grep -q '5000\|8888'; then
    echo -e "${YELLOW}🔥 iptables 规则存在${NC}"
fi

# 检查宝塔面板
if command -v bt &> /dev/null; then
    echo -e "${GREEN}📦 宝塔面板已安装${NC}"
    echo -e "${YELLOW}   请在宝塔面板 → 安全 中检查端口放行情况${NC}"
fi

# 5. 测试网络访问
echo ""
echo -e "${BLUE}5️⃣  测试网络访问...${NC}"

# 获取服务器 IP
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ip.sb 2>/dev/null || echo "无法获取")
echo -e "${BLUE}   服务器公网 IP：${SERVER_IP}${NC}"

# 测试本地访问
echo -e "${BLUE}   测试本地访问：${NC}"
curl -s -o /dev/null -w "   前端: http://127.0.0.1:5000 → %{http_code}\n" http://127.0.0.1:5000
curl -s -o /dev/null -w "   后端: http://127.0.0.1:8888/api → %{http_code}\n" http://127.0.0.1:8888/api

# 6. 诊断建议
echo ""
echo "=========================================="
echo -e "${BLUE}💡 诊断建议${NC}"
echo "=========================================="

if [ "$PM2_AVAILABLE" = false ]; then
    echo ""
    echo -e "${RED}1. PM2 未安装${NC}"
    echo "   执行以下命令安装："
    echo "   npm install -g pm2"
fi

if ! ss -ltn 2>/dev/null | grep -q ':5000' && ! netstat -ltn 2>/dev/null | grep -q ':5000'; then
    echo ""
    echo -e "${RED}2. 前端服务未运行${NC}"
    echo "   执行以下命令启动："
    echo "   cd frontend && pm2 start npm --name \"${PROJECT_NAME}-frontend\" -- start"
fi

if ! ss -ltn 2>/dev/null | grep -q ':8888' && ! netstat -ltn 2>/dev/null | grep -q ':8888'; then
    echo ""
    echo -e "${RED}3. 后端服务未运行${NC}"
    echo "   执行以下命令启动："
    echo "   pm2 start ./pansou --name \"${PROJECT_NAME}-backend}\""
fi

# 宝塔面板端口冲突警告
if ss -lptn 'sport = :8888' 2>/dev/null | grep -qv "pansou"; then
    echo ""
    echo -e "${RED}4. ⚠️  8888 端口与宝塔面板冲突${NC}"
    echo "   建议修改后端端口："
    echo "   1. 修改 install.sh 或 quick_start.sh 中的 PORT=8888 为其他端口（如 9999）"
    echo "   2. 重新启动后端服务"
    echo "   3. 在宝塔面板 → 安全 中放行新端口"
fi

# 7. 常用命令
echo ""
echo "=========================================="
echo -e "${BLUE}🔧 常用命令${NC}"
echo "=========================================="
echo ""
echo "查看 PM2 日志："
echo "   pm2 logs ${PROJECT_NAME}-frontend"
echo "   pm2 logs ${PROJECT_NAME}-backend"
echo ""
echo "重启服务："
echo "   pm2 restart ${PROJECT_NAME}-frontend"
echo "   pm2 restart ${PROJECT_NAME}-backend"
echo ""
echo "查看详细信息："
echo "   pm2 show ${PROJECT_NAME}-frontend"
echo "   pm2 show ${PROJECT_NAME}-backend"
echo ""

echo "=========================================="
echo -e "${GREEN}✅ 检查完成${NC}"
echo "=========================================="
