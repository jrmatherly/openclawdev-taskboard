# OpenClaw DEV Task Board - API Reference

> Complete API documentation with request/response examples
> Version: 1.2.0 | Base URL: `http://localhost:8080`

---

## Table of Contents

1. [Authentication](#authentication)
2. [Configuration](#configuration)
3. [Tasks](#tasks)
4. [Comments](#comments)
5. [Action Items](#action-items)
6. [Command Bar (Bot42)](#command-bar-bot42)
7. [Sessions](#sessions)
8. [WebSocket](#websocket)
9. [Error Handling](#error-handling)

---

## Authentication

Some endpoints require API key authentication.

### Headers

```http
Authorization: Bearer YOUR_API_KEY
```

or

```http
X-API-Key: YOUR_API_KEY
```

### Protected Endpoints

| Endpoint | Auth Required |
|----------|---------------|
| `POST /api/bot42/respond` | Yes |
| All other endpoints | No* |

*If `TASKBOARD_API_KEY` is not set, auth is disabled.

---

## Configuration

### GET /api/config

Get board configuration including agents, statuses, and branding.

**Response:**

```json
{
  "agents": ["Bot42", "Architect", "Security Auditor", "Code Reviewer", "UX Manager", "User", "Unassigned"],
  "statuses": ["Backlog", "In Progress", "Review", "Done", "Blocked"],
  "priorities": ["Critical", "High", "Medium", "Low"],
  "branding": {
    "mainAgentName": "Bot42",
    "mainAgentEmoji": "🛡️",
    "humanName": "User",
    "humanSupervisorLabel": "User",
    "boardTitle": "Task Board"
  }
}
```

### GET /api/activity

Get recent activity log.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | int | 50 | Max entries to return |

**Response:**

```json
[
  {
    "id": 1,
    "task_id": 5,
    "action": "moved",
    "agent": "User",
    "details": "Moved to In Progress",
    "timestamp": "2026-02-01T10:30:00"
  }
]
```

---

## Tasks

### GET /api/tasks

List all tasks with optional filters.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `board` | string | "tasks" | Board name |
| `agent` | string | null | Filter by agent |
| `status` | string | null | Filter by status |

**Response:**

```json
[
  {
    "id": 1,
    "title": "Implement auth system",
    "description": "Add JWT authentication",
    "status": "In Progress",
    "priority": "High",
    "agent": "Architect",
    "due_date": "2026-02-15",
    "created_at": "2026-02-01T09:00:00",
    "updated_at": "2026-02-01T10:30:00",
    "board": "tasks",
    "source_file": null,
    "source_ref": null,
    "working_agent": "Architect"
  }
]
```

### GET /api/tasks/{task_id}

Get a single task by ID.

**Response:**

```json
{
  "id": 1,
  "title": "Implement auth system",
  "description": "Add JWT authentication",
  "status": "In Progress",
  "priority": "High",
  "agent": "Architect",
  "due_date": "2026-02-15",
  "created_at": "2026-02-01T09:00:00",
  "updated_at": "2026-02-01T10:30:00",
  "board": "tasks",
  "working_agent": "Architect"
}
```

**Error Response (404):**

```json
{
  "detail": "Task not found"
}
```

### POST /api/tasks

Create a new task.

**Request Body:**

```json
{
  "title": "New feature",
  "description": "Implement the new feature",
  "status": "Backlog",
  "priority": "Medium",
  "agent": "Unassigned",
  "due_date": "2026-02-20",
  "board": "tasks",
  "source_file": "/path/to/file.py",
  "source_ref": "issue-123"
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `title` | string | Yes | - | Task title |
| `description` | string | No | "" | Task description |
| `status` | string | No | "Backlog" | Initial status |
| `priority` | string | No | "Medium" | Priority level |
| `agent` | string | No | "Unassigned" | Assigned agent |
| `due_date` | string | No | null | Due date (ISO format) |
| `board` | string | No | "tasks" | Board name |
| `source_file` | string | No | null | Source file reference |
| `source_ref` | string | No | null | External reference |

**Response:**

```json
{
  "id": 2,
  "title": "New feature",
  "description": "Implement the new feature",
  "status": "Backlog",
  "priority": "Medium",
  "agent": "Unassigned",
  "due_date": "2026-02-20",
  "created_at": "2026-02-01T11:00:00",
  "updated_at": "2026-02-01T11:00:00",
  "board": "tasks"
}
```

### PATCH /api/tasks/{task_id}

Update an existing task.

**Request Body:**

```json
{
  "title": "Updated title",
  "priority": "Critical",
  "agent": "Security Auditor"
}
```

All fields are optional. Only provided fields are updated.

**Response:** Updated task object

### DELETE /api/tasks/{task_id}

Delete a task.

**Response:**

```json
{
  "status": "deleted",
  "id": 1
}
```

### POST /api/tasks/{task_id}/move

Move a task to a new status with workflow rules.

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `status` | string | Yes | Target status |
| `agent` | string | No | Agent making the move |
| `reason` | string | No | Reason for move (required for Review/Blocked) |

**Workflow Rules:**

- Only `User` can move tasks to `Done`
- Moving to `In Progress` auto-spawns assigned agent
- Moving to `Review` creates completion action item
- Moving to `Blocked` creates blocker action item
- Moving to `Done` clears agent session

**Response:**

```json
{
  "status": "moved",
  "new_status": "In Progress",
  "action_item_created": false,
  "agent_spawned": true,
  "session_cleared": false
}
```

**Error Response (403):**

```json
{
  "detail": "Only User can move tasks to Done"
}
```

### POST /api/tasks/{task_id}/start-work

Mark that an agent is actively working on a task.

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `agent` | string | Yes | Agent name |

**Response:**

```json
{
  "status": "working",
  "task_id": 1,
  "agent": "Architect"
}
```

### POST /api/tasks/{task_id}/stop-work

Mark that an agent has stopped working.

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `agent` | string | No | Agent name |

**Response:**

```json
{
  "status": "stopped",
  "task_id": 1
}
```

### GET /api/agents/{agent}/tasks

Get all tasks assigned to a specific agent.

**Response:**

```json
[
  {
    "id": 1,
    "title": "Task assigned to agent",
    "status": "In Progress",
    ...
  }
]
```

---

## Comments

### GET /api/tasks/{task_id}/comments

Get all comments for a task.

**Response:**

```json
[
  {
    "id": 1,
    "task_id": 1,
    "agent": "Architect",
    "content": "## Architect Report\n\n**Verdict:** ✅ APPROVED",
    "created_at": "2026-02-01T10:45:00"
  }
]
```

### POST /api/tasks/{task_id}/comments

Add a comment to a task.

**Request Body:**

```json
{
  "agent": "User",
  "content": "@Security Auditor can you review the auth approach here?"
}
```

| Field | Type | Required | Max Size | Description |
|-------|------|----------|----------|-------------|
| `agent` | string | Yes | 100 chars | Comment author |
| `content` | string | Yes | 10MB | Comment content (supports Markdown) |

**@Mentions:** Comments containing `@Agent Name` will spawn the mentioned agent to respond.

**Response:**

```json
{
  "id": 2,
  "task_id": 1,
  "agent": "User",
  "content": "@Security Auditor can you review the auth approach here?",
  "created_at": "2026-02-01T11:00:00"
}
```

---

## Action Items

### GET /api/tasks/{task_id}/action-items

Get action items for a task.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `resolved` | bool | false | Include resolved items |
| `archived` | bool | false | Include archived items only |

**Response:**

```json
[
  {
    "id": 1,
    "task_id": 1,
    "comment_id": null,
    "agent": "Architect",
    "content": "Need clarification on API design",
    "item_type": "question",
    "resolved": 0,
    "created_at": "2026-02-01T10:30:00",
    "resolved_at": null,
    "archived": 0
  }
]
```

### POST /api/tasks/{task_id}/action-items

Create an action item.

**Request Body:**

```json
{
  "agent": "Security Auditor",
  "content": "Found potential SQL injection vulnerability",
  "item_type": "blocker",
  "comment_id": 5
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `agent` | string | Yes | Creator agent |
| `content` | string | Yes | Item description |
| `item_type` | string | No | "question", "completion", or "blocker" (default: "question") |
| `comment_id` | int | No | Related comment ID |

**Response:**

```json
{
  "id": 2,
  "task_id": 1,
  "comment_id": 5,
  "agent": "Security Auditor",
  "content": "Found potential SQL injection vulnerability",
  "item_type": "blocker",
  "resolved": 0,
  "created_at": "2026-02-01T11:15:00",
  "resolved_at": null
}
```

### POST /api/action-items/{item_id}/resolve

Resolve an action item.

**Response:**

```json
{
  "success": true,
  "item_id": 1
}
```

### POST /api/action-items/{item_id}/unresolve

Unresolve an action item (undo).

**Response:**

```json
{
  "success": true,
  "item_id": 1
}
```

### POST /api/action-items/{item_id}/archive

Archive a resolved action item.

**Response:**

```json
{
  "success": true,
  "item_id": 1
}
```

### POST /api/action-items/{item_id}/unarchive

Unarchive an action item.

**Response:**

```json
{
  "success": true,
  "item_id": 1
}
```

### DELETE /api/action-items/{item_id}

Delete an action item.

**Response:**

```json
{
  "success": true,
  "item_id": 1
}
```

---

## Command Bar (Bot42)

### GET /api/bot42/history

Get command bar chat history.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | int | 100 | Max messages |
| `session` | string | "main" | Session key |

**Response:**

```json
{
  "history": [
    {
      "id": 1,
      "session_key": "main",
      "role": "user",
      "content": "What's the status of the auth feature?",
      "timestamp": "2026-02-01T10:00:00"
    },
    {
      "id": 2,
      "session_key": "main",
      "role": "assistant",
      "content": "The auth feature is currently in Review...",
      "timestamp": "2026-02-01T10:00:05"
    }
  ],
  "session": "main"
}
```

### POST /api/bot42/chat

Send a message to the main agent.

**Request Body:**

```json
{
  "message": "What tasks are blocked?",
  "session": "main",
  "attachments": [
    {
      "type": "image/png",
      "data": "data:image/png;base64,iVBORw0KGgo...",
      "filename": "screenshot.png"
    }
  ]
}
```

| Field | Type | Required | Max Size | Description |
|-------|------|----------|----------|-------------|
| `message` | string | Yes | 10MB | User message |
| `session` | string | No | - | Session key (default: "main") |
| `attachments` | array | No | - | File attachments |

**Response:**

```json
{
  "sent": true,
  "response": "There are currently 2 blocked tasks: #5 and #8...",
  "session": "main"
}
```

**Error Response:**

```json
{
  "sent": false,
  "error": "OpenClaw integration not enabled."
}
```

### POST /api/bot42/respond

Push a response to the command bar (agent → UI).

**Authentication Required:** Yes

**Request Body:**

```json
{
  "response": "I've completed the analysis...",
  "session": "main"
}
```

| Field | Type | Required | Max Size | Description |
|-------|------|----------|----------|-------------|
| `response` | string | Yes | 1MB | Agent response |
| `session` | string | No | - | Session key (default: "main") |

**Response:**

```json
{
  "delivered": true
}
```

---

## Sessions

### GET /api/sessions

List all OpenClaw sessions.

**Response:**

```json
{
  "sessions": [
    {
      "key": "agent:main:main",
      "label": "🛡️ Bot42 (Main)",
      "channel": "",
      "model": "claude-sonnet-4",
      "updatedAt": 1706789100
    },
    {
      "key": "agent:main:subagent:abc123",
      "label": "🤖 task-5",
      "channel": "",
      "model": "claude-sonnet-4",
      "updatedAt": 1706789050
    }
  ]
}
```

### POST /api/sessions/create

Create a new OpenClaw session.

**Request Body:**

```json
{
  "label": "my-session",
  "agentId": "architect",
  "task": "Design the new API schema"
}
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `label` | string | No | Auto-generated | Session label |
| `agentId` | string | No | "main" | Agent ID |
| `task` | string | No | - | Initial task prompt |

**Response:**

```json
{
  "success": true,
  "result": {
    "childSessionKey": "agent:main:subagent:abc123",
    "runId": "run-456"
  }
}
```

### POST /api/sessions/{session_key}/stop

Stop a running session.

**Response:**

```json
{
  "success": true,
  "message": "Stop signal sent to: agent:main:subagent:abc123"
}
```

### POST /api/sessions/stop-all

Emergency stop all non-main sessions.

**Response:**

```json
{
  "success": true,
  "stopped": ["agent:main:subagent:abc123", "agent:main:subagent:def456"],
  "errors": [],
  "message": "Stopped 2 sessions"
}
```

### DELETE /api/sessions/{session_key}

Delete a session and its history.

**Response:**

```json
{
  "success": true,
  "message": "Deleted session: agent:main:subagent:abc123",
  "openclaw_deleted": true
}
```

---

## WebSocket

### Connection

```javascript
const ws = new WebSocket('ws://localhost:8080/ws');
```

### Keepalive

Send `ping`, receive `pong`.

```javascript
ws.send('ping');
// Response: 'pong'
```

### Event Types

All events are JSON objects with a `type` field.

#### task_created

```json
{
  "type": "task_created",
  "task": { "id": 1, "title": "New task", ... }
}
```

#### task_updated

```json
{
  "type": "task_updated",
  "task": { "id": 1, "title": "Updated task", ... }
}
```

#### task_deleted

```json
{
  "type": "task_deleted",
  "task_id": 1
}
```

#### comment_added

```json
{
  "type": "comment_added",
  "task_id": 1,
  "comment": { "id": 5, "agent": "User", "content": "..." }
}
```

#### action_item_added

```json
{
  "type": "action_item_added",
  "task_id": 1,
  "item": { "id": 3, "item_type": "question", ... }
}
```

#### action_item_resolved

```json
{
  "type": "action_item_resolved",
  "task_id": 1,
  "item_id": 3
}
```

#### work_started

```json
{
  "type": "work_started",
  "task_id": 1,
  "agent": "Architect"
}
```

#### work_stopped

```json
{
  "type": "work_stopped",
  "task_id": 1
}
```

#### command_bar_message

```json
{
  "type": "command_bar_message",
  "message": {
    "id": 10,
    "session_key": "main",
    "role": "assistant",
    "content": "Here's what I found...",
    "timestamp": "2026-02-01T11:30:00"
  }
}
```

#### session_deleted

```json
{
  "type": "session_deleted",
  "session_key": "agent:main:subagent:abc123"
}
```

---

## Error Handling

### HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 401 | Unauthorized (invalid API key) |
| 403 | Forbidden (access denied) |
| 404 | Not found |
| 422 | Validation error |
| 500 | Internal server error |

### Error Response Format

```json
{
  "detail": "Error message describing what went wrong"
}
```

### Validation Errors

```json
{
  "detail": [
    {
      "loc": ["body", "title"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

---

## Rate Limiting

No rate limiting is implemented. For production deployments, consider adding rate limiting via a reverse proxy (nginx, Traefik) or adding middleware.

---

## Legacy Endpoints

For backward compatibility, these legacy endpoints are available:

| Legacy | Current |
|--------|---------|
| `POST /api/molt/chat` | `POST /api/bot42/chat` |
| `POST /api/molt/respond` | `POST /api/bot42/respond` |

---

*Generated by sc:index | OpenClaw DEV Task Board v1.2.0*
