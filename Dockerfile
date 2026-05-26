FROM ghcr.io/linuxserver/baseimage-alpine:edge

RUN apk add --no-cache \
    aria2 \
    nodejs \
    grep

COPY root /

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