# 🎬 Nemi Cinema: Automated Media Pipeline

A lean, automated media pipeline using Docker. Maya (AI Agent) manages the workflow from search to acquisition and library organization.

## 🏗️ System Architecture
- **Jellyfin**: Media server and playback interface (Port `8096`).
- **Jackett**: Indexer aggregator (Standardized Torznab API) (Port `9117`).
- **aria2**: RPC-controlled download engine (Port `6800`).
- **Radarr**: Movie library management (Port `7878`).
- **Sonarr**: TV Show library management (Port `8989`).
- **Prowlarr**: Indexer and tracker manager (Port `9696`).
- **Lidarr**: Music library management (Port `8686`).
- **Bazarr**: Subtitle automatic downloader (Port `6767`).
- **Readarr**: Book and Audiobook library management (Port `8787`).
- **Flaresolverr**: Proxy server to bypass Cloudflare protection (Port `8191`).

## 📁 Standardized Isolated Paths
To keep the primary Jellyfin library folder (`./volumes/data`) pristine and avoid cross-container junk, each download client/service is isolated:
- **Root Library**: `./volumes/data/media/`
- **Jackett Downloads**: `./volumes/data/jackett`
- **Aria2 Downloads**: `./volumes/data/aria2`
- **Sonarr Downloads**: `./volumes/data/sonarr`
- **Radarr Downloads**: `./volumes/data/radarr`
- **Prowlarr Downloads**: `./volumes/data/prowlarr`
- **Lidarr Downloads**: `./volumes/data/lidarr`
- **Bazarr Downloads**: `./volumes/data/bazarr`
- **Readarr Downloads**: `./volumes/data/readarr`

## 🚀 Workflow & Orchestration

### 1. Discovery
Maya queries the Jackett or Prowlarr API to find media.
- **Jackett Endpoint**: `http://127.0.0.1:9117/api/v2.0/indexers/all/results/torznab/api`
- **Params**: `apikey=[API_KEY]`, `t=search`, `q=[QUERY]`

### 2. Acquisition
Maya triggers aria2 via JSON-RPC.
- **Endpoint**: `http://127.0.0.1:6800/jsonrpc`
- **Request Payload**:
```json
{
  "jsonrpc": "2.0",
  "method": "aria2.addUri",
  "params": ["token:[ARIA2_SECRET]", ["[MAGNET_URL]"], {"dir": "/downloads"}],
  "id": "1"
}
```

### 3. Cleanup & Organization
Once aria2 finishes:
1. **Move**: Move the media file (`.mkv`/`.mp4`) to the structured library vault: `/[PATH_TO_PROJECT]/volumes/data/media/TV Shows/[Show]/Season [X]/`.
2. **Discard**: Delete promotional `.txt`, `.url`, or `.torrent` residue.
3. **Keep**: `.nfo` files (if present).

## ⚙️ Configuration & Management

### Deployment
1. **Prepare**: Ensure `/volumes/` directories exist and `.env` is populated.
2. **Launch**: `make up`
3. **Tunnel**: Access Jackett/Services via SSH tunnel: `ssh -L 9117:127.0.0.1:9117 [USER]@[HOST_IP]`

### Operational Commands
- `make up`: Deploy/start all containers.
- `make down`: Stop all containers.
- `make logs`: Stream container logs.
- `make ps`: Check container status.

## 🧠 Agent Instructions
- **Search**: Use Jackett/Prowlarr Aggregate API for magnet links.
- **Download**: Trigger aria2 via JSON-RPC.
- **Vault**: Move finished media files to `/[PATH_TO_PROJECT]/volumes/data/media/[TV Shows|Movies]`.
- **Hygiene**: Aggressively discard non-media junk files from download residue.
