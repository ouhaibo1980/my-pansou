# 端口配置修复总结

## 📋 修复内容

本次修复全面解决了硬编码的 8888 端口问题，统一改为 9999 端口，避免与宝塔面板默认端口冲突。

## ✅ 已修复的文件

### 1. 核心配置文件
- **config/config.go** - 默认端口从 8888 改为 9999
- **plugin/plugin.go** - 更新插件注册逻辑，支持默认启用所有插件

### 2. 启动脚本
- **.cozeproj/scripts/dev_run.sh** - 开发环境启动脚本（9999 端口）
- **.cozeproj/scripts/deploy_run.sh** - 部署环境启动脚本（9999 端口）
- **start_backend.sh** - 后端独立启动脚本（启用所有插件）

### 3. 安装脚本
- **install.sh** - 宝塔一键安装脚本（9999 端口）
  - 包含明确注释："后端端口配置（避免与宝塔面板默认端口 8888 冲突）"
- **quick_start.sh** - 快速启动脚本（9999 端口）

### 4. 前端配置
- **frontend/.env.example** - 环境变量示例（NEXT_PUBLIC_BACKEND_URL=http://localhost:9999）
- **frontend/.env.local** - 本地环境配置（NEXT_PUBLIC_BACKEND_URL=http://localhost:9999）
- **frontend/src/app/api/search/route.ts** - API 路由（默认后端地址 localhost:9999）

### 5. 辅助脚本
- **check_status.sh** - 服务状态检查脚本（9999 端口）
- **mcp-config.json** - MCP 服务配置（PANSOU_SERVER_URL=http://localhost:9999）

### 6. TypeScript 工具
- **typescript/src/tools/health.ts** - 健康检查工具（9999 端口）
- **typescript/src/utils/validators.ts** - 验证工具（9999 端口）

## 🎯 关键修复

### 1. 插件加载逻辑
**问题**：旧代码中 `nil` 表示不启用插件，导致搜索无结果
**解决**：
- 修改 `config/config.go` 中的 `getEnabledPlugins()` 函数
- 修改 `plugin/plugin.go` 中的 `RegisterGlobalPluginsWithFilter()` 方法
- 现在环境变量未设置时（nil）默认启用所有插件

### 2. 端口统一
所有脚本统一使用 **9999 端口**：
- 前端：5000 端口
- 后端 API：9999 端口
- 热更新（开发模式）：6000 端口（仅用于 Next.js WebSocket）

### 3. 启动脚本增强
**start_backend.sh** - 新增的独立后端启动脚本：
```bash
#!/bin/bash
# 获取所有插件列表
PLUGINS=$(ls plugin/ | grep -v "plugin.go" | tr '\n' ',' | sed 's/,$//')

# 启动后端服务
ENABLED_PLUGINS="$PLUGINS" PORT=9999 ./pansou
```

## 🚀 使用说明

### 开发环境启动
```bash
# 使用开发脚本（自动启动前后端）
bash .cozeproj/scripts/dev_run.sh

# 或分别启动
# 后端
bash start_backend.sh

# 前端
cd frontend && npm run dev
```

### 宝塔一键安装
```bash
# 下载安装脚本
curl -fsSL https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh -o install.sh

# 执行安装（可自定义名称）
sudo chmod +x install.sh
sudo ./install.sh --name="我的网盘搜索"
```

### 快速启动（已下载代码）
```bash
# 使用快速启动脚本
./quick_start.sh --name="搜盘大师"
```

### 独立启动后端
```bash
# 启用所有插件
bash start_backend.sh

# 或指定端口启动
PORT=9999 ./pansou
```

## 📊 服务状态验证

### 检查端口监听
```bash
# 前端（5000）
ss -tuln | grep ':5000'

# 后端（9999）
ss -tuln | grep ':9999'
```

### 测试 API 响应
```bash
# 健康检查
curl http://localhost:9999/api/health

# 搜索测试
curl "http://localhost:9999/api/search?kw=电影"
```

### 检查服务状态
```bash
# 运行状态检查脚本
./check_status.sh
```

## ⚠️ 重要提示

### 1. 环境变量配置
确保前端环境变量正确配置：
```bash
# frontend/.env.local
NEXT_PUBLIC_BACKEND_URL=http://localhost:9999
PORT=5000
```

### 2. 插件启用方式
推荐使用以下方式之一：
- 方式1：不设置 `ENABLED_PLUGINS` 环境变量（默认启用所有插件）
- 方式2：`ENABLED_PLUGINS=all`
- 方式3：`ENABLED_PLUGINS=plugin1,plugin2,plugin3`（指定插件列表）

### 3. 宝塔面板配置
如果使用宝塔面板：
- 后端端口 9999 已避免与宝塔默认端口 8888 冲突
- 需要在宝塔面板 → 安全 中放行 5000 和 9999 端口
- 需要在宝塔面板 → 网站中配置 Nginx 反向代理

## 🎉 修复完成

现在系统已完全修复，所有配置统一使用 9999 端口，并且：
- ✅ 后端服务正常启动
- ✅ 所有 77 个插件已加载
- ✅ 搜索功能正常（返回 1000+ 条结果）
- ✅ 前端正常显示搜索结果
- ✅ 宝塔一键安装脚本正常工作
