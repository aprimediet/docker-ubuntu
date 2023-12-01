ARG UBUNTU_VERSION=jammy

FROM ubuntu:${UBUNTU_VERSION} AS base
LABEL maintainer="<Aditya Prima> aprimediet@gmail.com"

ARG UBUNTU_VERSION=jammy
ARG S6_VERSION=3.1.5.0
ARG UBUNTU_MIRROR=http://repo.ugm.ac.id/ubuntu
ARG SECURITY_MIRROR=http://security.ubuntu.com/ubuntu

ENV DEBIAN_FRONTEND noninteractive
# ADJUST LOCAL TIME
ENV TZ Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN touch /etc/apt/sources.list
RUN echo "deb ${UBUNTU_MIRROR}/ ${UBUNTU_VERSION} main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb ${UBUNTU_MIRROR}/ ${UBUNTU_VERSION}-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb ${UBUNTU_MIRROR}/ ${UBUNTU_VERSION}-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb ${SECURITY_MIRROR}/ ${UBUNTU_VERSION}-security main restricted universe multiverse" >> /etc/apt/sources.list

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
