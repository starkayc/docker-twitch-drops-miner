# Use a builder for downloading file
FROM ubuntu:22.04 AS builder

RUN apt-get update -y && \
    apt-get install -y wget unzip && \
    wget -P /tmp/ https://github.com/DevilXD/TwitchDropsMiner/releases/download/dev-build/Twitch.Drops.Miner.Linux.PyInstaller-x86_64.zip && \
    unzip -p /tmp/Twitch.Drops.Miner.Linux.PyInstaller-x86_64.zip "Twitch Drops Miner/Twitch Drops Miner (by DevilXD)" > /TwitchDropsMiner && \
    chmod +x /TwitchDropsMiner

# Switch to image were going to use for gui
FROM jlesage/baseimage-gui:ubuntu-22.04-v4.7.1

# Labels for the image
LABEL maintainer="StarKayC" \
    org.opencontainers.image.authors="DevilXD" \
    org.opencontainers.image.url="https://github.com/starkayc/docker-twitch-drops-miner" \
    org.opencontainers.image.documentation="https://github.com/DevilXD/TwitchDropsMiner?tab=readme-ov-file#usage" \
    org.opencontainers.image.source="https://github.com/DevilXD/TwitchDropsMiner" \
    org.opencontainers.image.vendor="StarKayC (Docker Image)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.title="TwitchDropsMiner Docker Image" \
    org.opencontainers.image.description="Dockerized version of DevilXD's TwitchDropsMiner. Allows AFK mining of Twitch drops with automatic claiming and channel switching."

# Set environments
ENV LANG=en_US.UTF-8 \
    TZ=Etc/UTC \
    DARK_MODE=1 \
    KEEP_APP_RUNNING=1 \
    TDM_VERSION_TAG=v16.dev.5f54c26 \
    APP_ICON_URL=https://raw.githubusercontent.com/DevilXD/TwitchDropsMiner/refs/heads/master/appimage/pickaxe.png

# Update the system while installing packages and cleaning up files
RUN apt-get update -y && \
    apt-get install -y wget gir1.2-appindicator3-0.1 fonts-noto-color-emoji fonts-wqy-zenhei language-pack-en && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/* /tmp/* /var/log/*

# Create the folders for the app and link the settings and cookies to a config folder for easy access. Set the file as executable and set folder permissions to 777 
RUN mkdir -p /TwitchDropsMiner/config && \
    ln -s /TwitchDropsMiner/config/settings.json /TwitchDropsMiner/settings.json && \
    ln -s /TwitchDropsMiner/config/cookies.jar /TwitchDropsMiner/cookies.jar && \
    printf '#!/bin/sh\ncd /TwitchDropsMiner\n./TwitchDropsMiner\n' > /startapp.sh && \
    chmod +x /startapp.sh && \
    chmod -R 777 /TwitchDropsMiner

# Copy app from builder
COPY --from=builder /TwitchDropsMiner /TwitchDropsMiner/TwitchDropsMiner

# Install app icon & set app name and version
RUN install_app_icon.sh "$APP_ICON_URL" && \
    set-cont-env APP_NAME "Twitch Drops Miner" && \
    set-cont-env APP_VERSION "$TDM_VERSION_TAG"