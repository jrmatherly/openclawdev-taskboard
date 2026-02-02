# OpenClaw DEV TaskBoard - Project Overview

## Purpose
Real-time Kanban board designed for **multi-agent AI workflows** with OpenClaw integration. Enables automated AI agent spawning when tasks move to "In Progress", persistent agent sessions per task, and @mention tagging for agent collaboration.

## Tech Stack
- **Backend**: Python 3.12+, FastAPI, SQLite, Pydantic v2
- **Frontend**: Vanilla JavaScript SPA, CSS (dark theme), Marked.js for Markdown
- **Real-time**: WebSocket for live updates
- **Deployment**: Docker, Docker Compose
- **AI Integration**: OpenClaw Gateway API for agent session management

## Key Features
- Live Kanban board with drag-and-drop
- Multi-agent assignment (Architect, Security Auditor, Code Reviewer, UX Manager)
- Auto-spawn agent sessions on task status change
- @Mention system to tag agents into conversations
- Action items (questions, blockers, completions)
- Command bar for direct agent chat
- Session isolation per task

## Project Structure
```
openclawdev-taskboard/
├── app.py                 # Main FastAPI application (~2,225 lines)
├── static/index.html      # Frontend SPA
├── data/                  # SQLite database (gitignored)
├── docs/                  # Documentation
│   ├── PROJECT_INDEX.md   # Quick reference index
│   ├── API_REFERENCE.md   # REST API documentation
│   ├── ARCHITECTURE.md    # System diagrams
│   ├── USER_GUIDE.md      # User documentation
│   └── openapi.yaml       # OpenAPI 3.0 spec
├── examples/              # Configuration examples
├── docker-compose.yml     # Container orchestration
├── Dockerfile             # Python ghcr.io/astral-sh/uv:python3.12-bookworm-slim
├── requirements.txt       # Python dependencies
└── .env.example           # Environment template
```

## Key Files
- `app.py` - All backend logic (routes, models, WebSocket, agent spawning)
- `static/index.html` - Complete frontend SPA
- `docs/PROJECT_INDEX.md` - Comprehensive project index (97% token savings)
