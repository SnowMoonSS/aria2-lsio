FROM ghcr.io/linuxserver/baseimage-alpine:edge

RUN apk add --no-cache aria2 nodejs

COPY root /

VOLUME \
    /config \
    /downloads