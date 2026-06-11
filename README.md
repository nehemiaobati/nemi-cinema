# Nemi Cinema

A comprehensive home media automation stack.

## 🚀 Services & Ports
- **Jellyfin**: `8096` (Media Server)
- **Radarr**: `7878` (Movies)
- **Sonarr**: `8989` (TV Shows)
- **Prowlarr**: `9696` (Indexers)
- **Lidarr**: `8686` (Music)
- **Readarr**: `8787` (Books/Audiobooks)
- **Bazarr**: `6767` (Subtitles)
- **Jackett**: `9117` (Indexers)
- **Aria2**: `6800` (Downloads)
- **FlareSolverr**: `8191` (Captcha Solver)

## 🛠 Architecture
- **Networking**: `network_mode: host` for all services.
- **Timezone**: `Africa/Nairobi`.
- **Storage Pattern**: 
  - Configs: Isolated in `./volumes/<service>-config`.
  - Media Library: Global root at `./volumes/data`.
  - Downloads: Isolated per-service at `./volumes/data/<service>`.

## ⚙️ Maintenance
- Run `make down` and `make up` to apply changes.
- Use `.env` for secrets (e.g., `ARIA2_SECRET`).
