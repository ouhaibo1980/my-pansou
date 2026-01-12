# 装歌盘搜

高性能网盘资源搜索引擎，提供美观的 Web 前端界面，支持 77 个搜索源插件。

## 功能特性

- 🚀 高性能并发搜索
- 🌐 支持 77 个搜索源插件（电影、音乐、软件、学习资源等）
- 💾 自动识别多种网盘类型（百度、阿里云、夸克、天翼云盘等）
- 🎨 美观的现代化 UI 界面
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
├── plugin/            # 77 个搜索源插件
├── pansou            # Go 后端二进制文件
├── cache/            # 缓存目录
└── .coze            # 项目配置
```

## 环境变量

- `PORT`: 后端 API 端口（默认 8888）
- `GOPROXY`: Go 模块代理
- `ENABLED_PLUGINS`: 启用的插件列表（77 个插件）

## 已启用的搜索源（77个）

### 电影/视频类 (优先级 1-2)
- ddys, erxiao, hdr4k, jutoushe, labi, libvio, lou1, panta, susu, wanou
- ahhhhfs, alupan, ash, clxiong, discourse, djgou, duoduo, dyyj, hdmoli
- huban, jsnoteclub, kkmao, leijing, meitizy, mikuclub, muou, nsgame
- ouge, panyq, shandian, xinjuc, ypfxw, yunsou

### 综合搜索类 (优先级 3)
- aikanzy, bixin, cldi, clmao, cyg, daishudj, feikuai, fox4k, gying, haisou
- hunhepan, jikepan, kkv, miaoso, mizixing, nyaa, pan666, pansearch, panwiki
- pianku, qingying, qqpd, quark4k, quarksoo, qupanshe, qupansou, sdso
- sousou, thepiratebay, weibo, wuji, xb6v, xdpan, xdyh, xiaoji, xiaozhang
- xys, yiove, yuhuage, zxzj

### 成人内容类 (优先级 5)
- javdb, u3c3

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

## 启动服务

```bash
# 开发环境
bash .cozeproj/scripts/dev_run.sh

# 生产环境
bash .cozeproj/scripts/deploy_run.sh
```

## 原项目地址

- [PanSou](https://github.com/ouhaibo1980/pansou) - 网盘搜索 API
