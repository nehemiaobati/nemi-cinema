# 🎬 Nemi Cinema: Automated Media Pipeline

A lean, automated media pipeline using Docker. Maya (AI Agent) manages the workflow from search to acquisition and library organization.

## 🏗️ System Architecture
- **Jellyfin**: Media server and playback interface.
- **Jackett**: Indexer aggregator (Standardized Torznab API).
- **aria2**: RPC-controlled download engine.

## 🚀 Workflow & Orchestration

### 1. Discovery
Maya queries the Jackett API to find media.
- **Endpoint**: `http://127.0.0.1:9117/api/v2.0/indexers/all/results/torznab/api`
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
3. **Tunnel**: Access Jackett via SSH tunnel: `ssh -L 9117:127.0.0.1:9117 [USER]@[HOST_IP]`

### Operational Commands
- `make up`: Deploy/start all containers.
- `make down`: Stop all containers.
- `make logs`: Stream container logs.
- `make ps`: Check container status.

## 🧠 Agent Instructions
- **Search**: Use Jackett Aggregate API for magnet links.
- **Download**: Trigger aria2 via JSON-RPC.
- **Vault**: Move finished media files to `/[PATH_TO_PROJECT]/volumes/data/media/[TV Shows|Movies]`.
- **Hygiene**: Aggressively discard non-media junk files from download residue.

