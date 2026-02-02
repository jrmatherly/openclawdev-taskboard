# API Quick Reference

## Base URL
`http://localhost:8080`

## Tasks

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks` | List tasks (query: board, agent, status) |
| GET | `/api/tasks/{id}` | Get single task |
| POST | `/api/tasks` | Create task |
| PATCH | `/api/tasks/{id}` | Update task |
| DELETE | `/api/tasks/{id}` | Delete task |
| POST | `/api/tasks/{id}/move` | Move to status (query: status, agent, reason) |
| POST | `/api/tasks/{id}/start-work` | Mark agent working (query: agent) |
| POST | `/api/tasks/{id}/stop-work` | Clear working indicator |

## Comments

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks/{id}/comments` | Get task comments |
| POST | `/api/tasks/{id}/comments` | Add comment (body: {agent, content}) |

## Action Items

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks/{id}/action-items` | Get action items |
| POST | `/api/tasks/{id}/action-items` | Create action item |
| POST | `/api/action-items/{id}/resolve` | Resolve item |
| POST | `/api/action-items/{id}/unresolve` | Unresolve item |
| POST | `/api/action-items/{id}/archive` | Archive item |
| DELETE | `/api/action-items/{id}` | Delete item |

## Chat (Command Bar)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/jarvis/history` | Get chat history |
| POST | `/api/jarvis/chat` | Send message to agent |
| POST | `/api/jarvis/respond` | Push agent response (requires API key) |

## Sessions

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/sessions` | List OpenClaw sessions |
| POST | `/api/sessions/create` | Create new session |
| POST | `/api/sessions/{key}/stop` | Stop session |
| POST | `/api/sessions/stop-all` | Emergency stop all |
| DELETE | `/api/sessions/{key}` | Delete session |

## Configuration

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/config` | Get board config (agents, statuses, branding) |
| GET | `/api/activity` | Get activity log |
| GET | `/api/agents/{agent}/tasks` | Get agent's tasks |

## WebSocket

| Endpoint | Description |
|----------|-------------|
| `WS /ws` | Real-time updates (send "ping" for keepalive) |

## Authentication

Protected endpoints require:
```
Authorization: Bearer YOUR_API_KEY
```
or
```
X-API-Key: YOUR_API_KEY
```
