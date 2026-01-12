# 装歌盘搜

高性能网盘资源搜索引擎，提供美观的 Web 前端界面，支持 77 个搜索源插件。

## 快速开始

### 本地安装

#### 前置要求

- Go 1.24+
- Node.js 18+
- pnpm (推荐)

#### 安装步骤

1. **克隆仓库**

```bash
git clone git@github.com:ouhaibo1980/my-pansou.git
cd my-pansou
```

2. **启动前端**

```bash
cd frontend
pnpm install
pnpm dev
```

前端将运行在 http://localhost:5000

3. **启动后端**

```bash
# 返回项目根目录
cd ..

# 下载依赖（如果需要）
go mod download

# 运行后端
go run main.go
```

后端 API 将运行在 http://localhost:8888

4. **访问应用**

打开浏览器访问：http://localhost:5000

## 功能特性

- 🚀 高性能并发搜索
- 🌐 支持 77 个搜索源插件（电影、音乐、软件、学习资源等）
- 💾 自动识别多种网盘类型（百度、阿里云、夸克、天翼云盘等）
- 🎨 美观的现代化 UI 界面
- ⚡ 智能结果排序
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
- Go 1.24
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
├── service/           # 业务逻辑
├── main.go           # Go 后端入口
└── cache/            # 缓存目录
```

## 环境变量

创建 `.env` 文件（可选）：

```env
# 服务端口
PORT=8888

# Go 模块代理（国内用户推荐）
GOPROXY=https://goproxy.cn,direct

# 启用的插件列表（77 个插件）
ENABLED_PLUGINS=labi,zhizhen,shandian,duoduo,muou,wanou,hunhepan,jikepan,panwiki,pansearch,panta,qupansou,hdr4k,pan666,susu,thepiratebay,xuexizhinan,panyq,ouge,huban,cyg,erxiao,miaoso,fox4k,pianku,clmao,wuji,cldi,xiaozhang,libvio,leijing,xb6v,xys,ddys,hdmoli,yuhuage,u3c3,javdb,clxiong,jutoushe,sdso,xiaoji,xdyh,haisou,bixin,djgou,nyaa,xinjuc,aikanzy,qupanshe,xdpan,discourse,yunsou,qqpd,ahhhhfs,nsgame,gying,quark4k,quarksoo,sousou,ash

# 缓存配置
CACHE_ENABLED=true
CACHE_PATH=./cache
CACHE_MAX_SIZE=100
CACHE_TTL=60

# 异步插件配置
ASYNC_PLUGIN_ENABLED=true
ASYNC_RESPONSE_TIMEOUT=4
ASYNC_MAX_BACKGROUND_WORKERS=20
ASYNC_MAX_BACKGROUND_TASKS=100
ASYNC_CACHE_TTL_HOURS=1

# 时区
TZ=Asia/Shanghai
```

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

## 常见问题

### Q: 前端无法连接后端 API？

A: 检查前端 `src/app/api/search/route.ts` 中的后端 API 地址是否正确（默认 `http://localhost:8888`）

### Q: 搜索结果为空？

A: 检查 `ENABLED_PLUGINS` 环境变量是否正确配置，部分插件可能需要代理访问

### Q: 如何启用代理？

A: 在环境变量中添加：
```env
PROXY=socks5://127.0.0.1:7890
```

### Q: 如何编译后端二进制文件？

A:
```bash
go build -o pansou main.go
./pansou
```

## 许可证

MIT
