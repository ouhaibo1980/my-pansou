# 装歌盘搜

高性能网盘资源搜索引擎，提供美观的 Web 前端界面，支持 77 个搜索源插件。

---

## ⭐ 核心功能：自定义项目名称

**装歌盘搜支持自定义项目名称，让你的网盘搜索服务拥有个性化品牌！**

### 🎯 功能说明

通过安装参数自定义项目名称，同时改变以下内容：
- **PM2 进程名称**：便于多实例管理
- **前端页面标题**：浏览器标签页和页面大标题
- **系统身份标识**：让你的搜索服务独一无二

### 💡 使用场景

1. **个性化品牌**：将 "装歌盘搜" 改为你的品牌名称
2. **多实例部署**：同一服务器部署多个实例，通过名称区分
3. **白标定制**：为不同客户或场景提供定制化服务
4. **团队标识**：使用团队或项目名称标识服务

### 📝 使用方法

#### 一键安装时指定名称

**方式 1：使用 --name 参数**

```bash
curl -fsSL https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh -o install.sh && \
sudo chmod +x install.sh && \
sudo ./install.sh --name="我的网盘搜索"
```

**方式 2：使用 ou 参数（更简洁）**

```bash
curl -fsSL https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh -o install.sh && \
sudo chmod +x install.sh && \
sudo ./install.sh ou="云盘搜"
```

#### 快速启动时指定名称

如果你已经下载了项目代码，可以使用快速启动脚本：

**使用 --name 参数**

```bash
./quick_start.sh --name="搜盘大师"
```

**使用 ou 参数**

```bash
./quick_start.sh ou="极速云搜"
```

### ✨ 效果示例

#### 默认名称（不传参数）
- **PM2 进程**：`装歌盘搜-frontend`、`装歌盘搜-backend`
- **页面标题**：装歌盘搜

#### 自定义名称（如：`ou="云盘搜"`）
- **PM2 进程**：`云盘搜-frontend`、`云盘搜-backend`
- **页面标题**：云盘搜

### 🔧 多实例管理示例

```bash
# 安装第一个实例
sudo ./install.sh ou="网盘搜索A"
pm2 list  # 会看到 "网盘搜索A-frontend" 和 "网盘搜索A-backend"

# 在另一个端口安装第二个实例（需要修改端口配置）
sudo ./install.sh ou="网盘搜索B"
pm2 list  # 会同时看到两个实例的进程

# 管理不同实例
pm2 logs "网盘搜索A-frontend"    # 查看实例A的日志
pm2 restart "网盘搜索B-backend"  # 重启实例B的后端
```

### ⚠️ 注意事项

1. **参数格式**：使用 `ou="名称"` 或 `--name="名称"` 格式，名称必须用引号包裹
2. **名称规范**：建议使用中文、英文或数字，避免特殊字符
3. **默认值**：不传参数时，默认使用 "装歌盘搜"
4. **持久化**：安装后名称已固化，修改名称需重新执行安装或手动配置
5. **PM2 管理**：使用自定义名称后的进程管理命令需要使用对应的名称

### 📌 快速命令参考

```bash
# 查看所有实例
pm2 list

# 查看自定义名称实例的日志
pm2 logs "我的网盘搜索-frontend"

# 重启自定义名称实例
pm2 restart "云盘搜-backend"

# 停止自定义名称实例
pm2 stop "搜盘大师-frontend"

# 删除自定义名称实例
pm2 delete "我的网盘搜索-backend"
```

---

## 快速安装（推荐）

### 真正的一键安装

无需预先克隆代码，直接执行以下命令即可完成全部安装。

**统一使用 Node.js 16.20.2，兼容所有 Linux 系统（包括 CentOS 7）**

**方式 1：直接安装（推荐）**

```bash
curl -fsSL https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**方式 2：使用 GitHub 代理（无法直接访问 GitHub 时使用）**

```bash
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**方式 2：使用 GitHub 代理（无法直接访问 GitHub 时使用）**

如果你的网络无法直接访问 GitHub，可以使用 GitHub 代理加速访问。

**推荐的 GitHub 代理：**

**代理 1：https://gh.ddlc.top（推荐，延迟低）**

```bash
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**代理 2：http://gh.927223.xyz（速度快）**

```bash
curl -fsSL http://gh.927223.xyz/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**代理 3：https://gh.felicity.ac.cn（稳定）**

```bash
curl -fsSL https://gh.felicity.ac.cn/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**代理 4：https://gh-proxy.com（常用）**

```bash
curl -fsSL https://gh-proxy.com/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**获取更多代理：**

可以从以下 API 获取最新的 GitHub 代理列表，并选择延迟最低的：

```bash
curl -s http://api.suxun.site/api/github
```

返回的 JSON 数据中包含 `url`、`latency`（延迟）、`location`（位置）等信息，选择 `latency` 最小的代理使用。

**使用方式：**

将 `https://raw.githubusercontent.com/...` 替换为 `代理地址/https://raw.githubusercontent.com/...`

例如：
- 原始：`https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh`
- 使用代理：`https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh`


**先下载再执行（更安全）**

```bash
curl -fsSL https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh -o install.sh && sudo chmod +x install.sh && sudo ./install.sh ou="装歌盘搜"
```


**先下载再执行（更安全）**

```bash
curl -fsSL https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh -o install.sh && sudo chmod +x install.sh && sudo ./install.sh ou="装歌盘搜"
```

**注意**：安装脚本已自动配置国内镜像源（npm/pnpm 使用淘宝镜像，Go 使用 goproxy.cn），无需手动配置。

这条命令会自动：
- 下载安装脚本
- 克隆项目代码
- 安装所有依赖（Node.js、PM2、Go、pnpm）
- 构建前端和后端
- 启动服务
- 配置开机自启

### 一键安装脚本（本地使用）

脚本会自动完成以下操作：
- 检测并安装 Node.js、PM2、Go、pnpm
- 克隆项目代码
- 编译后端
- 构建前端
- 启动服务
- 配置开机自启

**自定义项目名称**

你可以通过参数指定自定义的项目名称，PM2 进程名称和前端页面标题都会使用自定义名称：

**方式 1：使用 --name 参数**

```bash
./install.sh --name="我的网盘搜索"
```

**方式 2：使用 ou 参数**

```bash
./install.sh ou="云盘搜"
```

如果不指定参数，默认项目名称为 "装歌盘搜"。

### 快速启动脚本

适用于已下载项目代码的情况，快速启动服务。

```bash
# 快速启动服务
./quick_start.sh
```

**自定义项目名称**

```bash
# 使用 --name 参数
./quick_start.sh --name="我的网盘搜索"

# 使用 ou 参数
./quick_start.sh ou="云盘搜"
```

前端页面标题和 PM2 进程名称都会使用自定义名称。

**或者使用一键启动命令（无需预先克隆代码）**：

```bash
curl -fsSL https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/quick_start.sh -o quick_start.sh && chmod +x quick_start.sh && ./quick_start.sh ou="装歌盘搜"
```

**使用 GitHub 代理启动（无法直接访问 GitHub）**：

```bash
# 使用 GitHub 代理
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/quick_start.sh -o quick_start.sh && chmod +x quick_start.sh && ./quick_start.sh ou="装歌盘搜"
```


**注意**：这个命令需要在已克隆的项目目录中运行。


### 快速卸载脚本

适用于需要卸载服务的情况，一键删除项目文件和配置。

```bash
# 快速卸载服务
./uninstall.sh
```

**卸载内容**：
- 停止并删除 PM2 进程（${PROJECT_NAME}-frontend, ${PROJECT_NAME}-backend）
- 删除项目目录（/www/wwwroot/pansou）
- 可选：删除 PM2 配置
- 可选：卸载依赖软件（Node.js/Go/pnpm）

**使用 GitHub 代理下载卸载脚本**：

```bash
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/uninstall.sh -o uninstall.sh && chmod +x uninstall.sh && ./uninstall.sh
```

**卸载自定义名称实例**：

```bash
# 卸载自定义名称实例
./uninstall.sh --name="我的网盘搜索"

# 使用 ou 参数
./uninstall.sh ou="云盘搜"
```

**卸载确认**：

脚本会提示确认卸载操作，需要输入 `yes` 或 `y` 才能继续。

### 手动快速安装

如果你已经熟悉 Linux，可以使用以下命令快速安装：

```bash
# 1. 克隆代码
git clone git@github.com:ouhaibo1980/my-pansou.git pansou
cd pansou

# 2. 安装前端依赖并构建
cd frontend
pnpm install
pnpm build
pm2 start npm --name "pansou-frontend" -- start

# 3. 编译并启动后端
cd ..
go build -o pansou main.go
pm2 start ./pansou --name "pansou-backend"

# 4. 设置开机自启
pm2 save
```

**自定义进程名称**：

如果需要自定义 PM2 进程名称（例如：`my-search-frontend`、`my-search-backend`），修改上面的 `--name` 参数即可。

## 宝塔面板部署教程

### 前置准备

确保你已经安装了宝塔面板。如果没有安装，可以参考：
- [宝塔面板官网](https://www.bt.cn/)
- [宝塔安装教程](https://www.bt.cn/bbs/thread-19376-1-1.html)

### 安装步骤

#### 1. 安装环境软件

登录宝塔面板，进入 **软件商店**，安装以下软件：

1. **Nginx** - Web 服务器（用于反向代理前端）
2. **PM2 管理器** - Node.js 进程管理（用于运行前端）
3. **Go 语言** - 后端运行环境（如果没有预装）

**注意**：PM2 管理器会自动安装 Node.js，推荐安装 Node.js 18 或更高版本。

#### 2. 克隆代码

通过宝塔面板的 **终端** 或使用 SSH 连接到服务器：

```bash
# 进入网站根目录（默认为 /www/wwwroot）
cd /www/wwwroot

# 克隆仓库
git clone git@github.com:ouhaibo1980/my-pansou.git pansou

# 进入项目目录
cd pansou
```

如果没有配置 SSH，可以直接在宝塔面板中上传项目压缩包，然后解压。

#### 3. 部署前端

在宝塔终端中执行：

```bash
# 进入前端目录
cd /www/wwwroot/pansou/frontend

# 安装依赖
npm install -g pnpm
pnpm install

# 构建前端
pnpm build

# 使用 PM2 启动前端
pm2 start npm --name "pansou-frontend" -- start
```

**PM2 启动参数说明：**
- `npm` - 运行命令
- `--name "pansou-frontend"` - 进程名称（可自定义，如 `"my-frontend"`）
- `-- start` - 运行 npm start 命令

#### 4. 部署后端

在宝塔终端中执行：

```bash
# 返回项目根目录
cd /www/wwwroot/pansou

# 下载 Go 依赖
go mod download

# 编译后端（推荐方式，启动更快）
go build -o pansou main.go

# 使用 PM2 启动后端
pm2 start ./pansou --name "pansou-backend"
```

**说明**：编译成二进制文件后再运行，启动速度更快，更稳定。如果需要修改代码后重启，只需重新编译并执行 `pm2 restart pansou-backend`。

或者使用直接运行的方式（不推荐，每次启动都重新编译）：

```bash
# 直接使用 go run 运行（启动较慢）
pm2 start go run --name "pansou-backend" -- main.go
```

#### 5. 配置 Nginx 反向代理

在宝塔面板中：

1. 进入 **网站** → **添加站点**
2. 填写域名（如 `pansou.yourdomain.com`）
3. 提交后点击 **设置**
4. 选择 **配置文件** 选项卡

将以下配置粘贴到 `location /` 之前：

```nginx
# 前端代理
location / {
    proxy_pass http://127.0.0.1:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

# 后端 API 代理
location /api {
    proxy_pass http://127.0.0.1:8888;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

点击 **保存**，Nginx 会自动重载配置。

#### 6. 验证部署

1. **检查 PM2 进程状态**：
   ```bash
   pm2 list
   ```

   应该看到 `pansou-frontend` 和 `pansou-backend` 两个进程都在运行。

2. **访问应用**：
   - 打开浏览器访问你的域名
   - 尝试搜索功能，验证前后端通信正常

#### 7. 设置开机自启

在宝塔终端中执行：

```bash
# 保存 PM2 进程列表
pm2 save

# 设置开机自启（需要 root 权限）
pm2 startup
```

按照提示执行输出的命令即可。

### 常见问题

#### Q: PM2 命令找不到？

A: 确保 PM2 管理器已正确安装，或在宝塔面板的 **软件商店** 中重新安装。

#### Q: 前端端口 3000 被占用？

A: 可以修改 `frontend/package.json` 中的启动脚本，指定其他端口：
```json
"start": "next start -p 3001"
```
同时记得更新 Nginx 配置中的 `proxy_pass` 端口。

#### Q: 后端端口 8888 被占用？

A: 可以在 `main.go` 中修改端口，或者使用环境变量指定：
```bash
pm2 start go run --name "pansou-backend" -- main.go --port=8889
```

#### Q: 如何查看日志？

A: 使用 PM2 查看日志：
```bash
# 查看所有日志
pm2 logs

# 查看特定应用日志
pm2 logs pansou-frontend
pm2 logs pansou-backend

# 如果使用了自定义名称，使用你的自定义名称
pm2 logs my-frontend
pm2 logs my-backend

# 清空日志
pm2 flush
```

#### Q: 安装时报错 "Failed to connect to cdn.jsdelivr.net" 怎么办？

A: 这是因为网络无法访问 jsdelivr CDN，脚本已自动配置国内镜像源，但如果仍有问题：

**1. 手动配置 npm/pnpm 镜像源**

```bash
# 配置 npm 使用淘宝镜像
npm config set registry https://registry.npmmirror.com

# 配置 pnpm 使用淘宝镜像
pnpm config set registry https://registry.npmmirror.com
```

#### Q: 安装时报错 "不支持的指令" 或 "npm: command not found" 怎么办？

A: 这是宝塔面板安装命令不支持导致的，脚本已修复，支持多种 Linux 发行版：

**问题原因：**
- 宝塔面板的 `bt install pm2_manager` 命令在新版本中可能不兼容
- 导致 Node.js 安装失败，npm 命令不存在

**解决方案：**
最新版本的 install.sh（v1.1.1+）已修复此问题，支持：
- Ubuntu / Debian
- CentOS / RHEL / Rocky Linux
- OpenCloudOS / AnolisOS / 麒麟系统

**重新执行安装：**

```bash
# 重新下载最新脚本
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**手动安装 Node.js（如果脚本仍失败）：**

```bash
# Ubuntu/Debian 系统
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt-get install -y nodejs

# CentOS/RHEL/Rocky/OpenCloudOS 系统
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# 验证安装
node -v
npm -v
```

**2. 配置 Go 使用国内代理**

```bash
# 设置 Go 模块代理
export GOPROXY=https://goproxy.cn,direct

# 或写入配置文件永久生效
echo 'export GOPROXY=https://goproxy.cn,direct' >> ~/.bashrc
source ~/.bashrc
```

**3. 重新执行安装脚本**

脚本会自动使用配置好的镜像源：

```bash
sudo ./install.sh ou="装歌盘搜"
```

**4. 如果仍然失败，检查网络**

```bash
# 测试是否可以访问淘宝 npm 镜像
curl -I https://registry.npmmirror.com

# 测试是否可以访问 Go 代理
curl -I https://goproxy.cn
```

**注意**：最新版本的 install.sh 脚本（v1.1+）已自动配置国内镜像源，无需手动配置。

#### Q: 如何使用自定义的项目名称？

A: 在执行安装或启动脚本时，添加 `--name` 或 `ou` 参数：

```bash
# 一键安装时指定名称
./install.sh --name="我的网盘搜索"

# 快速启动时指定名称
./quick_start.sh ou="云盘搜"

# PM2 管理时使用对应的名称
pm2 logs "我的网盘搜索-frontend"
pm2 restart "云盘搜-backend"
```

**注意**：自定义名称会同时影响 PM2 进程名称和前端页面标题显示。

#### Q: 无法访问 GitHub 怎么办？

A: 如果无法访问 GitHub，可以使用以下方法：

**方法 1：使用 GitHub 代理（推荐，无需本地代理）**

使用公共 GitHub 代理，无需配置本地代理服务器：

```bash
# 推荐代理列表（延迟从低到高）
# 1. https://gh.ddlc.top
# 2. http://gh.927223.xyz
# 3. https://gh.felicity.ac.cn

# 使用示例
curl -fsSL https://gh.ddlc.top/https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**获取更多代理：**

```bash
# 获取最新代理列表
curl -s http://api.suxun.site/api/github
```

返回的数据包含多个代理，选择 `latency` 最小的使用。

**方法 2：使用本地代理执行安装命令**
```bash
# HTTP/HTTPS 代理
curl -fsSL -x http://127.0.0.1:7890 https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"

# SOCKS5 代理
curl -fsSL --socks5 127.0.0.1:7890 https://raw.githubusercontent.com/ouhaibo1980/my-pansou/main/install.sh | sudo bash -s -- ou="装歌盘搜"
```

**方法 3：配置 Git 代理**
```bash
# 配置 HTTP 代理
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

**方法 4：配置 Go 代理（下载依赖时）**
```bash
# 设置 Go 模块代理（国内用户推荐）
export GOPROXY=https://goproxy.cn,direct

# 或设置到环境变量文件
echo 'export GOPROXY=https://goproxy.cn,direct' >> /etc/profile
source /etc/profile
```

**方法 5：从国内镜像源下载**
如果有条件，可以先将代码下载到本地，然后上传到服务器。

#### Q: 如何重启服务？

A:
```bash
# 重启前端
pm2 restart pansou-frontend

# 重启后端
pm2 restart pansou-backend

# 如果使用了自定义名称
pm2 restart "my-frontend"
pm2 restart "my-backend"

# 重启所有服务
pm2 restart all
```

#### Q: 搜索结果为空？

A:
1. 检查后端进程是否正常运行：`pm2 logs pansou-backend`
2. 查看是否有网络请求错误
3. 部分插件可能需要配置代理（如使用机场代理）

## 本地开发

### 前置要求

- Go 1.24+
- Node.js 18+
- pnpm (推荐)

### 安装步骤

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

- **宝塔部署**: http://你的域名
- **本地开发前端**: http://localhost:5000
- **本地开发 API**: http://localhost:8888/api

## 技术栈

### 前端
- **Node.js >= 14.6.0**（推荐 16.x）
- Next.js 13.5.6 (App Router)
- React 18.2.0
- Tailwind CSS 4
- Lucide React (图标库)

### 后端
- Go 1.24
- Gin Web 框架

## 系统要求

### 最低要求
- **操作系统**：Linux（Ubuntu 18.04+, CentOS 7+, OpenCloudOS, 麒麟等）
- **内存**：>= 512MB
- **磁盘空间**：>= 2GB
- **Node.js**：18.20.4（脚本自动安装）
- **Go**：1.24

### 系统兼容性说明

**兼容所有主流 Linux 发行版：**
- ✅ CentOS 7 / OpenCloudOS / 麒麟系统（glibc 2.17）
- ✅ Ubuntu 18.04+ / Debian 10+
- ✅ CentOS 8+ / Rocky Linux / AlmaLinux
- ✅ 其他主流 Linux 发行版

**安装脚本统一使用 Node.js 16.20.2（官方二进制包），兼容所有系统**

**Next.js 版本说明：**
- 当前使用 **Next.js 13.5.6**（支持 Node.js >= 14.6.0）
- 兼容所有主流 Linux 发行版（包括 CentOS 7）

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
├── frontend/               # Next.js 前端项目
│   ├── src/
│   │   └── app/
│   │       └── page.tsx    # 主页面
│   └── package.json
├── plugin/                 # 77 个搜索源插件
├── service/                # 业务逻辑
├── typescript/             # MCP 服务
├── main.go                # Go 后端入口
├── cache/                 # 缓存目录
├── install.sh             # 一键安装脚本
└── quick_start.sh         # 快速启动脚本
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
