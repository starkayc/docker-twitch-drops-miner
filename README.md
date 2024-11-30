# docker-twitch-drops-miner

Based on this image: https://github.com/jlesage/docker-baseimage-gui
Based on DevilXD version of TwitchDropsMiner: https://github.com/DevilXD/TwitchDropsMiner

```
docker build -t starkayc/twitch-drops-miner:latest .
docker push starkayc/twitch-drops-miner:latest
```

Don't forget to mount `/config` to have data persistence.

You can also mount `/cache` to preserve cached images and mappings.

Available at: https://hub.docker.com/r/starkayc/twitchdropsminer