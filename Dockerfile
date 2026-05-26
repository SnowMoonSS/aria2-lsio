FROM ghcr.io/linuxserver/baseimage-alpine:edge AS builder

WORKDIR /app

RUN apk add --no-cache \
    wget \
    unzip \
    jq && \
    # get latest AriaNg release download URL
    ARIA_DOWNLOAD_URL=$(wget -qO- https://api.github.com/repos/mayswind/AriaNg/releases/latest \
        | jq -r '.assets[] | select(.name | test("\\.zip$")) | select(.name | test("AllInOne") | not) | .browser_download_url' \
        | head -1) && \
    wget -q "${ARIA_DOWNLOAD_URL}" -O ariang.zip && \
    unzip ariang.zip -d /app/ariang && \
    rm ariang.zip

FROM ghcr.io/linuxserver/baseimage-alpine:edge

RUN apk add --no-cache \
    aria2 \
    nodejs \
    grep

COPY root /

COPY --from=builder /app/ariang /app/ariang

# environment settings
ENV HOME="/config" \
    XDG_CONFIG_HOME="/config" \
    XDG_DATA_HOME="/config"

EXPOSE 6800 \
       6881-6999/tcp \
       6881-6999/udp

VOLUME \
    /config \
    /downloads