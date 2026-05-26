# aria2-docker

基于 Alpine 的轻量级 aria2 Docker 镜像，开箱即用，自动生成 RPC 密钥。

[![Docker Image CI](https://github.com/${{ github.repository }}/actions/workflows/docker-image.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/docker-image.yml)

## 特性

- 基于 `ghcr.io/linuxserver/baseimage-alpine:edge`，镜像体积小
- 首次启动自动复制默认配置文件到 `/config`
- 自动生成 14 位随机 RPC 密钥，并打印到控制台
- 内置 RPC 健康检查，确保服务就绪
- 非 root 用户运行（`abc`）

## 端口

| 端口 | 用途 |
|---|---|
| `6800` | JSON-RPC |
| `6881-6999` TCP/UDP | BT 下载 |

## 卷

| 路径 | 用途 |
|---|---|
| `/config` | 配置文件、session、日志 |
| `/downloads` | 下载目录 |

## 快速开始

### Docker Run

```bash
docker run -d \
  --name aria2 \
  -p 6800:6800 \
  -p 6881:6881/tcp \
  -p 6881:6881/udp \
  -v /path/to/config:/config \
  -v /path/to/downloads:/downloads \
  ghcr.io/<your-username>/aria2-docker:latest
```

首次启动后，查看日志获取 RPC 密钥：

```bash
docker logs aria2 | grep "RPC Secret"
```

### Docker Compose

```yaml
services:
  aria2:
    image: ghcr.io/<your-username>/aria2-docker:latest
    container_name: aria2
    ports:
      - "6800:6800"
      - "6881:6881/tcp"
      - "6881:6881/udp"
    volumes:
      - ./config:/config
      - ./downloads:/downloads
    environment:
      - PUID=1000 #可选
      - PGID=1000 #可选
      - UMASK=022 #可选
      - TZ=Asia/Shanghai #可选
    restart: unless-stopped
```

启动：

```bash
docker compose up -d
```

## 自定义配置

容器首次启动后，会在 `/config` 下生成 `aria2.conf`。你可以直接编辑该文件，然后重启容器使其生效：

```bash
docker compose restart
```

## 获取 RPC 密钥

容器首次启动时会自动生成 14 位随机密钥并输出：

```
RPC Secret: aB3xK9mR2pLq7v
```

也可通过以下命令查看：

```bash
grep "^rpc-secret=" /path/to/config/aria2.conf
```

## 健康检查

镜像使用 `s6-notifyoncheck` + JSON-RPC 轮询实现健康检查，确保容器仅在实际可用时标记为 `healthy`。

## 构建

```bash
docker build -t aria2-docker:latest .
```

## License

MIT
