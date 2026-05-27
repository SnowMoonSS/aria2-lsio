FROM ghcr.io/linuxserver/baseimage-alpine:edge AS builder

WORKDIR /app

RUN apk add --no-cache \
    grep \
    wget \
    unzip \
    git && \
    # get latest AriaNg version from git tags
    ARIA_VERSION=$(git ls-remote --tags --sort=-v:refname https://github.com/mayswind/AriaNg.git \
        | grep -oP 'refs/tags/\K[0-9.]+$' \
        | head -1) && \
    echo "Downloading AriaNg v${ARIA_VERSION}..." && \
    wget -q "https://github.com/mayswind/AriaNg/releases/download/${ARIA_VERSION}/AriaNg-${ARIA_VERSION}.zip" \
        -O ariang.zip && \
    unzip -q ariang.zip -d /app/ariang && \
    rm ariang.zip

FROM ghcr.io/linuxserver/baseimage-alpine:edge

RUN apk add --no-cache \
    aria2 \
    grep \
    darkhttpd

COPY root /

COPY --from=builder /app/ariang /app/ariang

# environment settings
ENV HOME="/config" \
    XDG_CONFIG_HOME="/config" \
    XDG_DATA_HOME="/config"

EXPOSE 80 \
       6800 \
       6881-6999/tcp \
       6881-6999/udp

VOLUME \
    /config \
    /downloads