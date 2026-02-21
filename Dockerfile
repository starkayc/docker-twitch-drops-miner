# syntax=docker/dockerfile:1.7

# -----------------------------------------------------------------------------
# Builder: prepare either a pinned v15 binary build or a source-based beta build
# -----------------------------------------------------------------------------
FROM ubuntu:22.04 AS builder

ARG TDM_CHANNEL=v15
ARG TDM_REF=master

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      ca-certificates wget unzip git && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -eux; \
    mkdir -p /out/app; \
    if [[ "${TDM_CHANNEL}" == "v15" ]]; then \
      wget -O /tmp/tdm.zip "https://github.com/DevilXD/TwitchDropsMiner/releases/download/v15/Twitch.Drops.Miner.Linux.PyInstaller-x86_64.zip"; \
      unzip -p /tmp/tdm.zip "Twitch Drops Miner/Twitch Drops Miner (by DevilXD)" > /out/app/TwitchDropsMiner; \
      chmod +x /out/app/TwitchDropsMiner; \
      echo '#!/bin/sh' > /out/run.sh; \
      echo 'cd /TwitchDropsMiner' >> /out/run.sh; \
      echo './TwitchDropsMiner' >> /out/run.sh; \
      echo 'v15' > /out/version.txt; \
    else \
      git clone --depth 1 --branch "${TDM_REF}" https://github.com/DevilXD/TwitchDropsMiner.git /out/app/src; \
      echo '#!/bin/sh' > /out/run.sh; \
      echo 'cd /TwitchDropsMiner/src' >> /out/run.sh; \
      echo 'exec python3 main.py' >> /out/run.sh; \
      echo "beta-${TDM_REF}" > /out/version.txt; \
    fi; \
    chmod +x /out/run.sh

# -----------------------------------------------------------------------------
# Runtime image
# -----------------------------------------------------------------------------
FROM jlesage/baseimage-gui:ubuntu-22.04-v4.7.1

ARG TDM_CHANNEL=v15
ARG TDM_REF=master

LABEL maintainer="schadis" \
    org.opencontainers.image.authors="DevilXD" \
    org.opencontainers.image.url="https://github.com/schadis/docker-twitch-drops-miner" \
    org.opencontainers.image.documentation="https://github.com/DevilXD/TwitchDropsMiner?tab=readme-ov-file#usage" \
    org.opencontainers.image.source="https://github.com/DevilXD/TwitchDropsMiner" \
    org.opencontainers.image.vendor="schadis (Docker Image)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.title="TwitchDropsMiner Docker Image" \
    org.opencontainers.image.description="Dockerized version of DevilXD's TwitchDropsMiner. Provides v15 and beta variants."

ENV LANG=en_US.UTF-8 \
    TZ=Etc/UTC \
    DARK_MODE=1 \
    KEEP_APP_RUNNING=1 \
    APP_ICON_URL=https://raw.githubusercontent.com/DevilXD/TwitchDropsMiner/refs/heads/master/appimage/pickaxe.png \
    TDM_CHANNEL=${TDM_CHANNEL} \
    TDM_REF=${TDM_REF}

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      wget git python3 python3-pip \
      gir1.2-appindicator3-0.1 fonts-noto-color-emoji fonts-wqy-zenhei language-pack-en && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/* /var/log/*

COPY --from=builder /out/app /TwitchDropsMiner/
COPY --from=builder /out/run.sh /startapp.sh
COPY --from=builder /out/version.txt /tmp/tdm-version.txt

RUN set -eux; \
    mkdir -p /config; \
    rm -rf /TwitchDropsMiner/config; \
    ln -s /config /TwitchDropsMiner/config; \
    ln -sf /TwitchDropsMiner/config/settings.json /TwitchDropsMiner/settings.json; \
    ln -sf /TwitchDropsMiner/config/cookies.jar /TwitchDropsMiner/cookies.jar; \
    chmod +x /startapp.sh; \
    if [[ "${TDM_CHANNEL}" == "beta" ]]; then \
      python3 -m pip install --no-cache-dir -r /TwitchDropsMiner/src/requirements.txt; \
    fi; \
    install_app_icon.sh "$APP_ICON_URL"; \
    set-cont-env APP_NAME "Twitch Drops Miner"; \
    set-cont-env APP_VERSION "$(cat /tmp/tdm-version.txt)"; \
    rm -f /tmp/tdm-version.txt; \
    chmod -R 777 /TwitchDropsMiner
