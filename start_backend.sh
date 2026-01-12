#!/bin/bash

# 装歌盘搜 - 后端启动脚本
# 启用所有插件并使用 9999 端口

# 获取所有插件列表
PLUGINS=$(ls plugin/ | grep -v "plugin.go" | tr '\n' ',' | sed 's/,$//')

# 启动后端服务
ENABLED_PLUGINS="$PLUGINS" PORT=9999 ./pansou
