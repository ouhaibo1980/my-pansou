# PanSou 网盘搜索

高性能网盘资源搜索引擎，提供美观的 Web 前端界面。

## 功能特性

- 🚀 高性能并发搜索
- 🌐 支持多种网盘类型（百度、阿里云、夸克、天翼云盘等）
- 💎 美观的现代化 UI 界面
- ⚡ 智能结果排序
- 🔌 异步插件系统
- 💾 二级缓存机制

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
├── pansou            # Go 后端二进制文件
└── cache/            # 缓存目录
```

## 环境变量

- `PORT`: 后端 API 端口（默认 8888）
- `GOPROXY`: Go 模块代理

## 原项目地址

- [PanSou](https://github.com/ouhaibo1980/pansou) - 网盘搜索 API
