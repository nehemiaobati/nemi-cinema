# Nemi Cinema - Media Automation Suite

## 🏗 Architecture: Single Data Pool
This setup uses a **Single Data Pool** strategy to ensure atomic moves and eliminate duplication.
- **Host Path:** `./volumes/data`
- **Container Path:** `/data` and `/downloads` (Mapped interchangeably across Arr services).
- **Benefit:** Files are moved instantly from download to library without copying across different virtual filesystems.

## 🛠 Management Commands
| Action | Command | Description |
| :--- | :--- | :--- |
| **Start/Update** | `make up` | Deploys/restarts containers in detached mode. |
| **Stop** | `make down` | Stops and removes containers. |
| **Logs** | `docker logs -f <service>` | Tail real-time logs for a specific service. |
| **Shell** | `make shell <service>` | Enter a container's bash shell. |

## 📡 Service Registry
| Service | Port | Description | Volume Mapping |
| :--- | :--- | :--- | :--- |
| **Jellyfin** | 8096 | Media Server | `/data` |
| **qBittorrent** | 8112 | Torrent Client | `/data` |
| **Sonarr** | 8989 | TV Series Management | `/data`, `/downloads` |
| **Radarr** | 7878 | Movie Management | `/data`, `/downloads` |
| **Lidarr** | 8686 | Music Management | `/data`, `/downloads` |
| **Readarr** | 8787 | Books Management | `/data`, `/downloads` |
| **Prowlarr** | 9696 | Indexer Management | `/config` |
| **Bazarr** | 6767 | Subtitle Management | `/data`, `/downloads` |
| **Jackett** | 9117 | Indexer Proxy | `/config` |
| **FlareSolverr**| 8191 | Captcha Solver | `/config` |

## 🔑 qBittorrent First-Run
The initial admin password is generated randomly at startup. To retrieve it, run:
```bash
docker logs qbittorrent
```
Look for the line: `The WebUI administrator password was generated and is: XXXXXXXX`

## 📂 Directory Structure (Host)
- `volumes/data/downloads` $\rightarrow$ Active downloads (Mapped to qBittorrent for incoming traffic).
- `volumes/data/media/Movies` $\rightarrow$ Final Movie Library.
- `volumes/data/media/TV Shows` $\rightarrow$ Final TV Library.
- `volumes/data/media/Music` $\rightarrow$ Final Music Library.
- `volumes/data/media/Photos` $\rightarrow$ Final Photos Library.

## ⚙️ Configuration Notes
- **User/Group:** All services run as `PUID=1000` and `PGID=1000`.
- **Network:** `network_mode: host` for maximum performance and simplified port management.
- **Timezone:** `Africa/Nairobi`.
