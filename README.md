# 装歌盘搜

高性能网盘资源搜索引擎，提供美观的 Web 前端界面，支持 77 个搜索源插件。

## 功能特性

- 🚀 高性能并发搜索
- 🌐 支持 77 个搜索源插件（电影、音乐、软件、学习资源等）
- 💾 自动识别多种网盘类型（百度、阿里云、夸克、天翼云盘等）
- 🎨 美观的现代化 UI 界面
- ⚡ 智能结果排序（优化 ouge 插件优先级）
- 🔌 异步插件系统
- 💾 二级缓存机制
- 🔒 自动过滤失效链接

## 访问地址

- **Web 前端**: http://localhost:5000
- **API 服务**: http://localhost:8888/api
- **健康检查**: http://localhost:8888/api/health

## 技术栈

### 前端
- Next.js 16 (App Router)
- React 19
- Tailwind CSS 4
- Lucide React (图标库)

### 后端
- Go 1.22
- Gin Web 框架

## API 接口

### 搜索接口
```
GET http://localhost:8888/api/search?keyword=搜索关键词
POST http://localhost:8888/api/search
Content-Type: application/json

{
  "keyword": "搜索关键词"
}
```

### 健康检查
```
GET http://localhost:8888/api/health
```

## 项目结构

```
.
├── frontend/          # Next.js 前端项目
│   ├── src/
│   │   └── app/
│   │       └── page.tsx    # 主页面
│   └── package.json
├── plugin/            # 77 个搜索源插件
├── pansou            # Go 后端二进制文件
├── cache/            # 缓存目录
└── .coze            # 项目配置
```

## 环境变量

- `PORT`: 后端 API 端口（默认 8888）
- `GOPROXY`: Go 模块代理
- `ENABLED_PLUGINS`: 启用的插件列表（77 个插件）

## 支持的网盘类型

百度网盘 (`baidu`)、阿里云盘 (`aliyun`)、夸克网盘 (`quark`)、天翼云盘 (`tianyi`)、UC网盘 (`uc`)、移动云盘 (`mobile`)、115网盘 (`115`)、PikPak (`pikpak`)、迅雷网盘 (`xunlei`)、123网盘 (`123`)、磁力链接 (`magnet`)、电驴链接 (`ed2k`)、其他 (`others`)

## 搜索结果示例

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total": 1420,
    "merged_by_type": {
      "aliyun": [
        {
          "url": "https://www.alipan.com/s/daARMGxX5RS",
          "password": "",
          "note": "青春猪头少年 系列 青春ブタ野郎 (2018-2026)",
          "datetime": "2026-01-10T20:17:43Z",
          "source": "plugin:susu"
        }
      ],
      "quark": [...],
      "baidu": [...]
    }
  }
}
```

## 自动同步到 GitHub

项目提供了便捷的自动同步功能，将代码推送到 GitHub 仓库供他人部署。

### 方式一：手动触发同步

当你修改代码后，运行此脚本会自动检测变动并推送到 GitHub：

```bash
# 检测变动并自动同步
./auto_sync_to_github.sh
```

脚本会自动：
- 检测文件变动
- 添加所有更改
- 提交（带时间戳）
- 推送到 GitHub

### 方式二：后台自动监控（推荐）

启动守护进程后，每 10 秒自动检测变动并同步：

```bash
# 启动守护进程
./watch_and_sync.sh start

# 停止守护进程
./watch_and_sync.sh stop

# 查看运行状态
./watch_and_sync.sh status
```

**特点：**
- 完全自动化，无需手动操作
- 每 10 秒检测一次变动
- 日志记录同步历史：`/tmp/pansou_sync.log`

### GitHub 仓库

- **仓库地址**: https://github.com/ouhaibo1980/my-pansou
- **SSH URL**: git@github.com:ouhaibo1980/my-pansou.git

**注意**：首次使用需要配置 SSH 密钥并添加到 GitHub 账户。

## 原项目地址

- [PanSou](https://github.com/ouhaibo1980/pansou) - 网盘搜索 API
