ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION} AS base
LABEL maintainer="<Aditya Prima> aprimediet@gmail.com"

ARG S6_VERSION=3.1.5.0

WORKDIR /root

# Install base dependencies
RUN --mount=type=cache,target=/var/cache/apt/archives \
    apt -y update && apt -y upgrade && apt -y install bash curl xz-utils

# Get S6-OVERLAY
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-x86_64.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp

# Install S6-Overlay
RUN tar -Jxpf /tmp/s6-overlay-noarch.tar.xz -C / && \
    tar -Jxpf /tmp/s6-overlay-x86_64.tar.xz -C / && \
    tar -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz -C /

# Remove S6-Overlay
RUN rm -f /tmp/s6-overlay-noarch.tar.xz && \
    rm -f /tmp/s6-overlay-x76_64.tar.xz && \
    rm -f /tmp/s6-overlay-symlinks-noarch.tar.xz

# Clean APT Cache
RUN apt -y clean

ENTRYPOINT [ "/init" ]
