# TwitchDropsMiner Docker

A Dockerized version of [TwitchDropsMiner](https://github.com/DevilXD/TwitchDropsMiner), built on [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui).

📦 Available on [Docker Hub](https://hub.docker.com/r/starkayc/twitch-drops-miner) and [GHCR](https://ghcr.io/starkayc/twitch-drops-miner).

---

## 📥 Installation (Recommended)

1. **Create `compose.yaml`**:

```yaml
services:
  twitchdropminer:
    image: starkayc/twitch-drops-miner
    container_name: twitchdropminer
    restart: unless-stopped
    ports:
      - "5800:5800"
    volumes:
      - ./config:/TwitchDropsMiner/config
      - ./cache:/TwitchDropsMiner/cache
```

2. **Create folders**:

```bash
mkdir config cache
```

3. **Run the container**:

```bash
docker compose up -d
```

4. Open your browser and go to:  
`http://<server-ip>:5800`

---

## 🛠️ Manual Build (Optional)

If you prefer building the image yourself:

1. **Clone the repo**:

```bash
git clone https://github.com/starkayc/docker-twitch-drops-miner
cd docker-twitch-drops-miner
```

2. **Build the image**:

```bash
docker build -t twitch-drops-miner .
```

3. **Create folders and run**:

```bash
mkdir config cache
docker run -p 5800:5800 --restart=unless-stopped \
  -v "$PWD/config:/TwitchDropsMiner/config" \
  -v "$PWD/cache:/TwitchDropsMiner/cache" \
  twitch-drops-miner
```

4. Access the UI at `http://<server-ip>:5800`

---

## 📎 Resources

- Base GUI Image: [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui)  
- TwitchDropsMiner: [DevilXD/TwitchDropsMiner](https://github.com/DevilXD/TwitchDropsMiner)