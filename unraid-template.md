# Unraid Template Fields (copy guide)

Create two containers with identical settings except image/tag, ports and appdata path.

## Shared fields

- Network Type: `bridge`
- WebUI: `http://[IP]:[PORT:5800]/`
- Console shell: `Shell`

## Stable v15

- Repository: `ghcr.io/schadis/docker-twitch-drops-miner:v15`
- Name: `twitch-drops-miner`
- Ports:
  - Host `5800` -> Container `5800` (TCP)
  - Host `5900` -> Container `5900` (TCP)
- Path:
  - Host `/mnt/user/appdata/twitch-drops-miner` -> Container `/config`

## Beta

- Repository: `ghcr.io/schadis/docker-twitch-drops-miner:beta`
- Name: `twitch-drops-miner-beta`
- Ports:
  - Host `5801` -> Container `5800` (TCP)
  - Host `5901` -> Container `5900` (TCP)
- Path:
  - Host `/mnt/user/appdata/twitch-drops-miner-beta` -> Container `/config`

## Notes

- Keep separate appdata paths for stable and beta.
- Beta tracks latest upstream `master` at image build time.
- v15 is pinned to upstream release v15.
