# OpenManus-Docker

A Docker wrapper for [OpenManus](https://github.com/FoundationAgents/OpenManus) — the open-source AI agent framework. Runs the full stack (agent + browser automation + LLM backend) in containers with no host-side Python setup required.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) with Compose (v2)
- `make`
- An Anthropic API key — _only_ if using the Claude-backed presets

---

## Quick start

### Option A — Fully local (free, no API key)

Uses [Ollama](https://ollama.com/) running inside Docker. No cloud services needed.

**1. Clone this repo**

```bash
git clone https://github.com/rozek/OpenManus-Docker
cd OpenManus-Docker
```

**2. Build the image** _(first time only, ~10 min)_

```bash
make build
```

**3. Pull the Ollama models** _(one-time, ~16 GB total)_

```bash
docker compose up -d ollama
docker compose exec ollama ollama pull qwen2.5:14b      # main agent (~9 GB)
docker compose exec ollama ollama pull llama3.2-vision  # vision tasks (~7 GB)
```

**4. Run**

```bash
make run-local
```

---

### Option B — Claude Haiku + local fallback _(default)_

Fast and cheap. Manus agent uses Claude Haiku; Ollama handles the fallback tier; vision uses Claude Sonnet.

**1.** Complete steps 1–3 from Option A.

**2.** Edit `config/config.toml` and replace both `sk-ant-YOUR_ANTHROPIC_KEY` placeholders with your real key.

**3. Run**

```bash
make run
```

---

### Option C — Claude Opus _(most capable)_

For complex reasoning and research tasks. Opus as the main agent, Sonnet for vision.

**1.** Edit `config/presets/opus.toml` and replace all `sk-ant-YOUR_ANTHROPIC_KEY` placeholders.

**2. Run**

```bash
make run-opus
```

---

## All make targets

| Command | What it does |
|---|---|
| `make build` | Build the Docker image |
| `make rebuild` | Force-rebuild from scratch (no cache) |
| `make run` | Haiku (main) + Ollama fallback + Sonnet vision |
| `make run-local` | All Ollama — completely free |
| `make run-opus` | Claude Opus (main) + Sonnet vision |
| `make shell` | Open a bash shell inside the running container |
| `make logs` | Tail container logs |
| `make clean` | Remove containers and image |

---

## Configuration

All config lives in `config/`. The mounted file structure:

```
config/
├── config.toml          # Default config (used by make run)
└── presets/
    ├── local.toml       # All Ollama (used by make run-local)
    └── opus.toml        # Claude Opus (used by make run-opus)
```

### Model tiers (default `config.toml`)

| Section | Model | Purpose |
|---|---|---|
| `[llm]` | `qwen2.5:14b` via Ollama | Free fallback for any unnamed agent |
| `[llm.manus]` | Claude Haiku | Main Manus agent |
| `[llm.vision]` | Claude Sonnet | All vision / multimodal tasks |

Each agent picks up the config section matching its lowercase name. Any agent without a named section falls back to `[llm]`.

### Alternative models

`config.toml` includes commented-out blocks for:

- OpenAI GPT-4o / GPT-4o-mini
- Groq Llama 3.3 70B (free cloud tier)
- Claude Opus 4
- Local Llama 3.2 Vision via Ollama

Copy any block into `[llm.manus]` to swap the main agent.

---

## Hardware notes

- Ollama runs on CPU if no GPU is present. On a Ryzen 5700G (64 GB RAM): `qwen2.5:14b` runs at ~4–8 tok/s.
- GPU acceleration (NVIDIA/AMD) requires additional Docker configuration not covered here.

---

## Interacting with OpenManus

Once running, the container is interactive. If using Docker Desktop, select the `openmanus-1` container and open the **Exec** tab. From the terminal, type your task prompt and press Enter.

---

## Licence

[MIT](LICENSE.md)
