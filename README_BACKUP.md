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

