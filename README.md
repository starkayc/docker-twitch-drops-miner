# TwitchDropsMiner Docker (schadis)

Docker image for [DevilXD/TwitchDropsMiner](https://github.com/DevilXD/TwitchDropsMiner) based on [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui).

## Image tags

This repo publishes two variants to GHCR:

- `ghcr.io/schadis/docker-twitch-drops-miner:v15`  
  Stable base using upstream **v15** PyInstaller release.
- `ghcr.io/schadis/docker-twitch-drops-miner:beta`  
  Built from latest upstream `master` source on every workflow run.
- `ghcr.io/schadis/docker-twitch-drops-miner:latest`  
  Alias of `v15`.

---

## Docker Compose examples

### Stable v15

```yaml
services:
  twitchdropminer:
    image: ghcr.io/schadis/docker-twitch-drops-miner:v15
    container_name: twitchdropminer
    restart: unless-stopped
    ports:
      - "5800:5800"
      - "5900:5900"
    volumes:
      - ./config:/config
```

### Beta (latest upstream master)

```yaml
services:
  twitchdropminer-beta:
    image: ghcr.io/schadis/docker-twitch-drops-miner:beta
    container_name: twitchdropminer-beta
    restart: unless-stopped
    ports:
      - "5801:5800"
      - "5901:5900"
    volumes:
      - ./config-beta:/config
```

Open UI via:
- `http://<server-ip>:5800` (v15)
- `http://<server-ip>:5801` (beta)

---

## Unraid usage

You can create **two templates/containers** in Unraid:

### 1) Stable container (v15)

- Repository: `ghcr.io/schadis/docker-twitch-drops-miner:v15`
- Name: `twitch-drops-miner`
- Ports:
  - `5800 -> 5800`
  - `5900 -> 5900`
- Path:
  - `/mnt/user/appdata/twitch-drops-miner` -> `/config`
- Restart: your preference (`unless-stopped` recommended)

### 2) Beta container (master)

- Repository: `ghcr.io/schadis/docker-twitch-drops-miner:beta`
- Name: `twitch-drops-miner-beta`
- Ports:
  - `5801 -> 5800`
  - `5901 -> 5900`
- Path:
  - `/mnt/user/appdata/twitch-drops-miner-beta` -> `/config`
- Restart: your preference (`unless-stopped` recommended)

This lets you run v15 and beta side-by-side without conflicts.

---

## Build automation

GitHub Actions builds and pushes:
- `v15` and `latest` (stable)
- `beta` (latest upstream master)

Trigger: push to `main` or manual workflow dispatch.
