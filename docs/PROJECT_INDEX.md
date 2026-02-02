# OpenClaw DEV Task Board - Project Index

> **Comprehensive technical documentation for the OpenClaw DEV Task Board project**
> Generated: 2026-02-01 | Version: 1.2.0 | License: MIT
> Token Efficiency: ~1,500 tokens (vs ~58,000 for full codebase = **97% savings**)

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [File Structure](#file-structure)
4. [Core Components](#core-components)
5. [API Reference](#api-reference)
6. [Database Schema](#database-schema)
7. [Configuration](#configuration)
8. [Security Model](#security-model)
9. [Agent System](#agent-system)
10. [WebSocket Events](#websocket-events)
11. [Deployment](#deployment)
12. [Development Guide](#development-guide)

---

## Project Overview

The **OpenClaw DEV Task Board** is a real-time Kanban board designed for **multi-agent AI workflows**. It integrates with [OpenClaw](https://github.com/openclaw/openclaw) to enable:

- **Automated agent spawning** when tasks move to "In Progress"
- **Persistent agent sessions** with isolated context per task
- **Real-time updates** via WebSocket
- **@Mention system** to tag agents into conversations
- **Action items** for tracking questions, blockers, and completions

### Key Features

| Feature | Description |
|---------|-------------|
| Live Kanban | Real-time drag-and-drop task management |
| Multi-Agent | Architect, Security Auditor, Code Reviewer, UX Manager |
| Auto-Spawn | Agents activate automatically on task status change |
| Session Isolation | Each task maintains its own agent context |
| Command Bar | Direct chat with main agent from header |
| Action Items | Questions, blockers, completion tracking |

### Technology Stack

- **Backend:** Python 3.12+, FastAPI, SQLite, Pydantic
- **Frontend:** Vanilla JavaScript, CSS (dark theme), Marked.js
- **Real-time:** WebSocket
- **Deployment:** Docker, Docker Compose
- **Integration:** OpenClaw Gateway API

---

## Architecture

```mermaid
┌─────────────────────────────────────────────────────────────┐
│                    Task Board UI (index.html)               │
│   • Kanban columns • Task cards • Command bar • Modals     │
└─────────────────────┬───────────────────────────────────────┘
                      │ WebSocket + REST API
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                 FastAPI Backend (app.py)                    │
│   • Task CRUD • Comments • Action Items • Sessions          │
│   • WebSocket Manager • Agent Spawning • Security           │
└─────────────────────┬───────────────────────────────────────┘
                      │ SQLite
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                  SQLite Database (tasks.db)                 │
│   • tasks • comments • action_items • chat_messages         │
│   • activity_log • deleted_sessions                         │
└─────────────────────────────────────────────────────────────┘
                      │
                      │ /tools/invoke
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                   OpenClaw Gateway                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   Main   │  │ Architect│  │ Security │  │   Code   │   │
│  │  Agent   │  │          │  │ Auditor  │  │ Reviewer │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

1. **User Action** → Task Board UI
2. **API Call** → FastAPI Backend
3. **Database Update** → SQLite
4. **WebSocket Broadcast** → All connected clients
5. **Agent Spawn** (on status change) → OpenClaw Gateway
6. **Agent Response** → POST to Task Board API
7. **Live Update** → WebSocket to UI

---

## File Structure

```tree
openclawdev-taskboard/
├── app.py                    # Main FastAPI application (2225 lines)
├── docker-compose.yml        # Docker orchestration
├── Dockerfile               # Container build instructions
├── requirements.txt         # Python dependencies
├── .env.example            # Environment template
├── .gitignore              # Git ignore rules
├── README.md               # User documentation
├── OPENCLAW_SETUP.md       # Integration guide
├── CHANGELOG.md            # Version history
├── LICENSE                 # MIT License
├── scripts/
│   └── start.ps1           # Windows startup script
├── static/
│   └── index.html          # Frontend SPA (~47K tokens)
├── examples/
│   ├── dev-team-example.md # Agent configuration template
│   └── moltbot-agents.yaml # YAML agent definitions
├── data/                   # SQLite database (gitignored)
│   └── tasks.db
└── docs/
    └── PROJECT_INDEX.md    # This file
```

---

## Core Components

### Backend (`app.py`)

| Component | Lines | Description |
|-----------|-------|-------------|
| Configuration | 1-102 | Environment variables, branding, agent mapping |
| Security | 103-177 | API key verification, internal-only checks |
| Agent Integration | 178-617 | OpenClaw session spawning, messaging |
| WebSocket Manager | 619-649 | Connection pool, broadcast |
| Database | 651-774 | SQLite schema, migrations, activity log |
| Models | 776-818 | Pydantic models for Tasks, Comments, etc. |
| Task Endpoints | 902-1042 | CRUD operations |
| Work Status | 1044-1233 | start-work, stop-work, move task |
| Comments | 1235-1416 | Comment CRUD, @mentions |
| Action Items | 1418-1605 | Questions, blockers, completions |
| Activity Log | 1607-1621 | Recent activity feed |
| Command Bar | 1623-2218 | Chat with main agent, session management |

### Frontend (`static/index.html`)

Single-page application with:

- **Header:** Title, command bar, session selector, new task button
- **Kanban Board:** 5 columns (Backlog, In Progress, Review, Done, Blocked)
- **Task Cards:** Drag-and-drop, priority badges, agent icons, action bubbles
- **Modals:** Task detail, comments, action items, edit forms
- **WebSocket Client:** Real-time updates, ping/pong keepalive

---

## API Reference

### Tasks

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/tasks` | List tasks (filter by board, agent, status) |
| `GET` | `/api/tasks/{id}` | Get single task |
| `POST` | `/api/tasks` | Create task |
| `PATCH` | `/api/tasks/{id}` | Update task |
| `DELETE` | `/api/tasks/{id}` | Delete task |
| `POST` | `/api/tasks/{id}/move` | Move to status (auto-spawns agent) |
| `POST` | `/api/tasks/{id}/start-work` | Mark agent as working |
| `POST` | `/api/tasks/{id}/stop-work` | Clear working indicator |

### Comments

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/tasks/{id}/comments` | Get task comments |
| `POST` | `/api/tasks/{id}/comments` | Add comment (triggers @mentions) |

### Action Items

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/tasks/{id}/action-items` | Get action items |
| `POST` | `/api/tasks/{id}/action-items` | Create action item |
| `POST` | `/api/action-items/{id}/resolve` | Resolve item |
| `POST` | `/api/action-items/{id}/unresolve` | Unresolve item |
| `POST` | `/api/action-items/{id}/archive` | Archive item |
| `POST` | `/api/action-items/{id}/unarchive` | Unarchive item |
| `DELETE` | `/api/action-items/{id}` | Delete item |

### Command Bar (Jarvis Chat)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/jarvis/history` | Get chat history |
| `POST` | `/api/jarvis/chat` | Send message to agent |
| `POST` | `/api/jarvis/respond` | Agent pushes response (requires API key) |

### Sessions

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/sessions` | List OpenClaw sessions |
| `POST` | `/api/sessions/create` | Create new session |
| `POST` | `/api/sessions/{key}/stop` | Stop session |
| `POST` | `/api/sessions/stop-all` | Emergency stop all |
| `DELETE` | `/api/sessions/{key}` | Delete session |

### Configuration

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/config` | Get board config (agents, statuses, branding) |
| `GET` | `/api/activity` | Recent activity log |
| `GET` | `/api/agents/{agent}/tasks` | Get agent's tasks |

### WebSocket

| Endpoint | Description |
|----------|-------------|
| `WS /ws` | Real-time updates (ping/pong keepalive) |

---

## Database Schema

### `tasks`

```sql
CREATE TABLE tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT DEFAULT '',
    status TEXT DEFAULT 'Backlog',
    priority TEXT DEFAULT 'Medium',
    agent TEXT DEFAULT 'Unassigned',
    due_date TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    board TEXT DEFAULT 'tasks',
    source_file TEXT,
    source_ref TEXT,
    working_agent TEXT DEFAULT NULL,
    agent_session_key TEXT DEFAULT NULL
);
```

### `comments`

```sql
CREATE TABLE comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_id INTEGER NOT NULL,
    agent TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TEXT NOT NULL
);
```

### `action_items`

```sql
CREATE TABLE action_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_id INTEGER NOT NULL,
    comment_id INTEGER,
    agent TEXT NOT NULL,
    content TEXT NOT NULL,
    item_type TEXT DEFAULT 'question',  -- question, completion, blocker
    resolved INTEGER DEFAULT 0,
    created_at TEXT NOT NULL,
    resolved_at TEXT,
    archived INTEGER DEFAULT 0
);
```

### `chat_messages`

```sql
CREATE TABLE chat_messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_key TEXT DEFAULT 'main',
    role TEXT NOT NULL,  -- user, assistant
    content TEXT NOT NULL,
    attachments TEXT,    -- JSON array
    created_at TEXT NOT NULL
);
```

### `activity_log`

```sql
CREATE TABLE activity_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_id INTEGER,
    action TEXT NOT NULL,
    agent TEXT,
    details TEXT,
    timestamp TEXT NOT NULL
);
```

### `deleted_sessions`

```sql
CREATE TABLE deleted_sessions (
    session_key TEXT PRIMARY KEY,
    deleted_at TEXT NOT NULL
);
```

---

## Configuration

### Environment Variables

#### OpenClaw Integration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `OPENCLAW_GATEWAY_URL` | No | `http://host.docker.internal:18789` | Gateway URL |
| `OPENCLAW_TOKEN` | Yes* | - | Gateway API token |
| `TASKBOARD_API_KEY` | Recommended | - | API key for protected endpoints |

*Required for AI features

#### Project Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `PROJECT_NAME` | My Project | Project name in agent prompts |
| `COMPANY_NAME` | Acme Corp | Company name in prompts |
| `COMPANY_CONTEXT` | software development | Context for agents |
| `ALLOWED_PATHS` | /workspace, /project | Filesystem boundaries |
| `COMPLIANCE_FRAMEWORKS` | your security requirements | Compliance context |

#### Branding

| Variable | Default | Description |
|----------|---------|-------------|
| `MAIN_AGENT_NAME` | Jarvis | Main agent display name |
| `MAIN_AGENT_EMOJI` | 🛡️ | Main agent emoji |
| `HUMAN_NAME` | User | Human user display name |
| `HUMAN_SUPERVISOR_LABEL` | User | Supervisor label |
| `BOARD_TITLE` | Task Board | Page title |

---

## Security Model

### Authentication

- **API Key:** `Authorization: Bearer <token>` or `X-API-Key: <token>`
- **Internal-only:** Restricts access to localhost/Docker IPs
- **Secrets comparison:** Uses `secrets.compare_digest` for timing-safe comparison

### CORS

```python
ALLOWED_ORIGINS = [
    "http://localhost:8080",
    "http://127.0.0.1:8080",
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]
```

### File Upload Limits

- Maximum attachment size: **10MB**
- Response size limit: **1MB**

### Agent Guardrails

Agents receive mandatory constraints:

- Filesystem boundaries
- Forbidden actions (browser, git commit, external APIs)
- Compliance context
- Communication protocols

---

## Agent System

### Agent Mapping

| Display Name | OpenClaw ID | Focus |
|--------------|-------------|-------|
| Main Agent | `main` | Coordination, implementation |
| Architect | `architect` | System design, patterns |
| Security Auditor | `security-auditor` | SOC2, HIPAA, CIS compliance |
| Code Reviewer | `code-reviewer` | Code quality, best practices |
| UX Manager | `ux-manager` | User flows, UI consistency |

### Agent Spawning

When a task moves to "In Progress":

1. Backend calls `sessions_spawn` via OpenClaw Gateway
2. Agent receives task prompt with guardrails
3. Agent session key stored in `tasks.agent_session_key`
4. Agent posts updates as comments
5. Session cleared when task moves to "Done"

### @Mentions

Pattern: `@Agent Name` (case-insensitive)

When detected in a comment:

1. Mentioned agent is spawned with context
2. System comment posted noting the spawn
3. Agent reviews and responds in thread

### Follow-up Sessions

When user replies to an active task:

1. Try to send to existing session (`sessions_send`)
2. If session ended, spawn new follow-up session with context

---

## WebSocket Events

### Outbound (Server → Client)

| Event Type | Payload | Description |
|------------|---------|-------------|
| `task_created` | `{task}` | New task created |
| `task_updated` | `{task}` | Task modified |
| `task_deleted` | `{task_id}` | Task removed |
| `comment_added` | `{task_id, comment}` | Comment posted |
| `action_item_added` | `{task_id, item}` | Action item created |
| `action_item_resolved` | `{task_id, item_id}` | Item resolved |
| `action_item_unresolved` | `{task_id, item_id}` | Item unresolved |
| `action_item_archived` | `{task_id, item_id}` | Item archived |
| `action_item_unarchived` | `{task_id, item_id}` | Item unarchived |
| `action_item_deleted` | `{task_id, item_id}` | Item deleted |
| `work_started` | `{task_id, agent}` | Agent started working |
| `work_stopped` | `{task_id}` | Agent stopped working |
| `command_bar_message` | `{message}` | Chat message |
| `session_deleted` | `{session_key}` | Session removed |

### Inbound (Client → Server)

| Message | Response |
|---------|----------|
| `ping` | `pong` |

---

## Deployment

### Docker Compose

```yaml
services:
  taskboard:
    build: .
    container_name: openclaw-dev-taskboard
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - ./data:/app/data
      - ./static:/app/static
    env_file:
      - .env
    environment:
      - PYTHONUNBUFFERED=1
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

### Quick Start

```bash
# Clone
git clone https://github.com/openclaw/openclaw-taskboard.git
cd openclaw-taskboard

# Configure
cp .env.example .env
# Edit .env with your tokens

# Start
docker-compose up -d

# Access
open http://localhost:8080
```

### Dependencies

```txt
fastapi>=0.100.0
uvicorn[standard]>=0.23.0
pydantic>=2.0.0
websockets>=12.0
httpx>=0.27.0
```

---

## Development Guide

### Local Development

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Install dependencies
pip install -r requirements.txt

# Run development server
python app.py
# or
uvicorn app:app --reload --host 0.0.0.0 --port 8080
```

### Adding New Agents

1. **Update `AGENT_TO_OPENCLAW_ID`** in `app.py`:

   ```python
   AGENT_TO_OPENCLAW_ID = {
       "Your Agent": "your-agent-id",
       # ...
   }
   ```

2. **Add system prompt** to `AGENT_SYSTEM_PROMPTS`:

   ```python
   AGENT_SYSTEM_PROMPTS = {
       "your-agent-id": "Your agent's role and instructions...",
       # ...
   }
   ```

3. **Update frontend** in `static/index.html`:

   ```javascript
   const AGENT_ICONS = {
       'Your Agent': '🚀',
       // ...
   };
   ```

4. **Add to AGENTS list**:

   ```python
   AGENTS = [
       # ...
       "Your Agent",
   ]
   ```

### Workflow States

```mermaid
graph TD;
    Backlog → In Progress → Review → Done
              ↓
           Blocked
```

- **Backlog:** Tasks waiting to be started
- **In Progress:** Agent session auto-spawns
- **Review:** Agent completed, awaiting approval
- **Done:** Human approval only (agents cannot set)
- **Blocked:** Waiting on external input

### Testing

```bash
# Test API
curl http://localhost:8080/api/config

# Test WebSocket
websocat ws://localhost:8080/ws
> ping
< pong

# Test task creation
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Task", "agent": "Architect"}'
```

---

## Documentation Index

| Document | Purpose | Audience |
|----------|---------|----------|
| [README.md](../README.md) | Quick start and overview | Everyone |
| [USER_GUIDE.md](USER_GUIDE.md) | Step-by-step usage guide | End users |
| [API_REFERENCE.md](API_REFERENCE.md) | Complete REST API docs | Developers |
| [ARCHITECTURE.md](ARCHITECTURE.md) | System design and data flows | Developers |
| [openapi.yaml](openapi.yaml) | OpenAPI 3.0 specification | API consumers |
| [OPENCLAW_SETUP.md](../OPENCLAW_SETUP.md) | OpenClaw integration guide | DevOps |
| [CHANGELOG.md](../CHANGELOG.md) | Version history | Everyone |
| [examples/](../examples/) | Configuration templates | DevOps |

---

*Generated by sc:index-repo | OpenClaw DEV Task Board v1.2.0*
