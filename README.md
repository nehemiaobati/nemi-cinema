# 🎬 Nemi Cinema: Automated Media Pipeline

Nemi Cinema is a lean, high-performance media acquisition and streaming stack. Instead of using bloated "Arr" suites, this system utilizes a customized orchestration layer (Maya) to manage the flow from request to playback.

## 🏗️ System Architecture

The stack consists of three core services running in a unified Docker environment using `network_mode: host` for maximum transparency and performance.

### 1. The Engine Room
- **Jellyfin**: The media server and frontend for playback.
- **Jackett**: The indexer aggregator. It transforms various torrent tracker searches into a standardized Torznab API.
- **aria2**: A lightweight, multi-protocol download engine controlled via JSON-RPC.

### 2. The Orchestrator (Maya)
Maya acts as the Intelligent UI. She handles the logic that would typically require a complex web interface:
`User Request` $\rightarrow$ `Jackett Search` $\rightarrow$ `Magnet Selection` $\rightarrow$ `aria2 Trigger` $\rightarrow$ `File Organization` $\rightarrow$ `Jellyfin Playback`.

---

## 🔄 Complete Operational Workflow

### Step 1: Discovery (Jackett)
When a request is made (e.g., "Find The Boys S04E01"), the orchestrator queries the Jackett Aggregate API.

**API Endpoint:**
`http://127.0.0.1:9117/api/v2.0/indexers/all/results/torznab/api?apikey=[API_KEY]&t=search&q=[QUERY]`

**Logic:**
- The `/all/` endpoint is used to search all configured indexers simultaneously.
- The orchestrator parses the XML response to find the best match based on quality (e.g., 720p, 1080p) and seed count.

### Step 2: Acquisition (aria2)
Once a magnet link is selected, it is sent to the aria2 RPC interface.

**RPC Protocol:** JSON-RPC 2.0
**Port:** 6800
**Sample Request:**
```json
{
  "jsonrpc": "2.0",
  "method": "aria2.addUri",
  "params": [
    "token:[ARIA2_SECRET]",
    ["magnet:?xt=urn:btih:..."],
    { "dir": "/downloads" }
  ],
  "id": "1"
}
```

### Step 3: Organization & Delivery
Files are downloaded into the shared volume vault. To ensure Jellyfin recognizes the content correctly, files are moved from the temporary download folder into the structured media library.

**Cleanup Policy:**
- **Keep**: The actual media file (`.mkv`, `.mp4`, etc.) and any `.nfo` files.
- **Discard**: All promotional `.txt`, `.url`, or other junk files. These are not necessary for the Jellyfin experience as it uses online scrapers for metadata.

**Path Mapping:**
- **Download Root**: `/home/newuser/docker/nemi-cinema/volumes/data`
- **Media Vault**: `/home/newuser/docker/nemi-cinema/volumes/data/media/`
  - `/TV Shows/[Show Name]/Season [X]/`
  - `/Movies/`

---

## ⚙️ Configuration & Management

### Environment Variables (`.env`)
- `JACKETT_API_KEY`: The key retrieved from the Jackett dashboard.
- `ARIA2_SECRET`: The RPC token used to authenticate requests to aria2.
- `MEDIA_PATH`: The absolute path to the media vault.

### Management Commands
The project uses a `Makefile` for standardized lifecycle management:
- `make up`: Deploys the entire stack.
- `make down`: Stops all services.
- `make logs`: Tails logs for all containers.

### Manual Setup (First Time Only)
1. **Tunneling**: Use SSH tunneling to access the Jackett config page securely:
   `ssh -L 9117:127.0.0.1:9117 newuser@138.197.91.217`
2. **Indexers**: Navigate to `http://localhost:9117` and add the desired torrent indexers.

---

## 🧠 Agent Instructions for Future Context
If you are an AI agent taking over this system:
1. **Search**: Use the Jackett Aggregate API to find magnet links.
2. **Download**: Use `curl` to send JSON-RPC requests to `http://127.0.0.1:6800`.
3. **Organize & Clean**: After download completion, move the resulting `.mkv`/`.mp4` file into the `/media/TV Shows/` or `/media/Movies/` directory. Discard all promotional `.txt` and `.url` files to keep the vault pristine.
4. **Verify**: Check the `/volumes/data` directory to track download progress.
