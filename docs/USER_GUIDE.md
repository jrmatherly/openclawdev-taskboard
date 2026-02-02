# OpenClaw DEV Task Board - User Guide

> Step-by-step guide to using the multi-agent AI Task Board
> Version: 1.2.0

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Understanding the Interface](#understanding-the-interface)
3. [Working with Tasks](#working-with-tasks)
4. [Interacting with AI Agents](#interacting-with-ai-agents)
5. [Using the Command Bar](#using-the-command-bar)
6. [Action Items](#action-items)
7. [Keyboard Shortcuts](#keyboard-shortcuts)
8. [Troubleshooting](#troubleshooting)

---

## Getting Started

### Prerequisites

Before using the Task Board, ensure you have:

- A modern web browser (Chrome, Firefox, Safari, Edge)
- The Task Board running at `http://localhost:8080`
- (Optional) OpenClaw configured for AI agent automation

### First Launch

1. Open your browser and navigate to `http://localhost:8080`
2. You'll see the Kanban board with five columns:
   - **Backlog** - Tasks waiting to be started
   - **In Progress** - Tasks currently being worked on
   - **Review** - Tasks awaiting approval
   - **Done** - Completed tasks
   - **Blocked** - Tasks waiting on external input

---

## Understanding the Interface

### Header

```mermaid
┌─────────────────────────────────────────────────────────────────┐
│ </> DEV Task Board    [Command Bar...]    [Sessions ▼] [+ New] │
└─────────────────────────────────────────────────────────────────┘
```

| Element | Purpose |
|---------|---------|
| **Logo** | Click to refresh the board |
| **Command Bar** | Chat directly with your AI agent |
| **Session Selector** | Switch between agent conversations |
| **+ New Task** | Create a new task |

### Task Cards

Each task card shows:

```mermaid
┌────────────────────────────┐
│ 🟠 HIGH                    │  ← Priority badge
│ Review auth system         │  ← Title
│                            │
│ 🔄 Architect              │  ← Working indicator + Agent
│ [🟡1] [🔴1]               │  ← Action item badges
└────────────────────────────┘
```

**Priority Colors:**

- 🔴 **Critical** - Highest priority
- 🟠 **High** - Important
- 🟡 **Medium** - Normal
- 🟢 **Low** - When time permits

**Action Item Badges:**

- 🟡 **Questions** - Agent needs clarification
- 🟢 **Completions** - Work ready for review
- 🔴 **Blockers** - Something is blocking progress

**Working Indicator:**

- 🔄 Spinning icon means an agent is actively working on the task

---

## Working with Tasks

### Creating a Task

1. Click the **+ New Task** button in the header
2. Fill in the task details:
   - **Title** (required) - Brief description of the task
   - **Description** - Detailed information (Markdown supported)
   - **Priority** - Critical, High, Medium, or Low
   - **Agent** - Who should work on this task
   - **Due Date** - Optional deadline
3. Click **Create Task**

### Moving Tasks

**Drag and Drop:**

1. Click and hold a task card
2. Drag it to the desired column
3. Release to drop

**Important Workflow Rules:**

| From | To | What Happens |
|------|-----|--------------|
| Any | **In Progress** | Agent session auto-spawns |
| Any | **Review** | Completion action item created |
| Any | **Blocked** | Blocker action item created |
| Any | **Done** | Only you (User) can do this |

### Viewing Task Details

Click on any task card to open the detail modal:

```mermaid
┌─────────────────────────────────────────────────────────────────┐
│ [Edit] [Delete]                                            [×] │
├─────────────────────────────────────────────────────────────────┤
│ Review auth system                                              │
│ ─────────────────                                               │
│ Status: In Progress    Priority: High    Agent: Security Auditor│
│                                                                 │
│ Description:                                                    │
│ Audit the authentication flow for security vulnerabilities...   │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│ Comments (3)                              [Type a comment...  ] │
│ ────────────                                                    │
│ 🤖 System: Security Auditor agent spawned automatically.       │
│                                                                 │
│ 🔒 Security Auditor: ## Analysis                               │
│    Found 2 potential issues...                                  │
│                                                                 │
│ 👤 User: Can you elaborate on issue #2?                        │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│ Action Items (2 open)                               [+ Add New] │
│ ────────────────────                                            │
│ 🟡 [Question] Need clarification on JWT expiry     [✓ Resolve] │
│ 🟢 [Completion] Ready for review                   [✓ Resolve] │
│                                                                 │
│ [Show Resolved]                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Editing a Task

1. Click on the task to open details
2. Click the **Edit** button
3. Modify the fields you want to change
4. Click **Save Changes**

### Deleting a Task

1. Click on the task to open details
2. Click the **Delete** button
3. Confirm the deletion

> ⚠️ **Warning:** Deletion is permanent and cannot be undone.

---

## Interacting with AI Agents

### Available Agents

| Agent | Icon | Expertise |
|-------|------|-----------|
| **Main Agent** | 🛡️ | General coordination, command bar chat |
| **Architect** | 🏛️ | System design, patterns, scalability |
| **Security Auditor** | 🔒 | SOC2, HIPAA, vulnerability assessment |
| **Code Reviewer** | 📋 | Code quality, best practices |
| **UX Manager** | 🎨 | User flows, UI consistency |

### Assigning Tasks to Agents

1. Create or edit a task
2. Select an agent from the dropdown
3. Move the task to **In Progress**
4. The agent session spawns automatically

### @Mentioning Agents

You can tag agents into any conversation using @mentions:

```bash
@Security Auditor can you review the auth approach here?
@Architect what do you think about the proposed design?
```

**What happens:**

1. The mentioned agent receives the task context
2. A system message notes the agent was tagged
3. The agent analyzes and responds in the thread

### Agent Reports

Agents post their findings as formatted comments:

```markdown
## Security Auditor Report

**Task:** Review auth system
**Verdict:** ⚠️ CONCERNS

### Findings
- [HIGH] JWT tokens don't expire
- [MEDIUM] Password reset lacks rate limiting

### Summary
Two issues found that should be addressed before production.
```

---

## Using the Command Bar

The command bar lets you chat directly with your main AI agent.

### Opening the Command Bar

1. Click the command bar in the header
2. Or press **Ctrl+K** / **Cmd+K**

### Chatting with the Agent

```mermaid
┌─────────────────────────────────────────────────────────────────┐
│ 🛡️ Jarvis (Main)                                         [▢] [×]│
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ 👤 What tasks are currently blocked?                           │
│                                                                 │
│ 🛡️ There are 2 blocked tasks:                                  │
│    - #5: Database migration (waiting for credentials)          │
│    - #8: API integration (external service down)               │
│                                                                 │
│ 👤 Can you check on task #5 for me?                            │
│                                                                 │
│ 🛡️ Task #5 is blocked waiting for production database         │
│    credentials. The action item was created 2 hours ago...     │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│ [Type your message...                             ] [📎] [Send] │
└─────────────────────────────────────────────────────────────────┘
```

### Session Management

**Switching Sessions:**

1. Click the session dropdown
2. Select a different session (e.g., a task-specific agent session)

**Creating New Sessions:**

- Sessions are created automatically when agents spawn
- Main session is always available

**Deleting Sessions:**

1. Click the session dropdown
2. Click the delete icon next to a session
3. Confirm deletion

### File Attachments

1. Click the 📎 icon or paste an image
2. Supported formats: Images, text files
3. The agent can analyze attached content

---

## Action Items

Action items track what needs attention on each task.

### Types of Action Items

| Type | Icon | Purpose | Auto-Created |
|------|------|---------|--------------|
| **Question** | 🟡 | Agent needs clarification | Manual |
| **Completion** | 🟢 | Work is ready for review | When → Review |
| **Blocker** | 🔴 | Something is blocking progress | When → Blocked |

### Creating Action Items

1. Open a task
2. Click **+ Add New** in the Action Items section
3. Select the type (Question, Completion, Blocker)
4. Enter the description
5. Click **Add**

### Resolving Action Items

1. Open the task with the action item
2. Click **✓ Resolve** next to the item
3. The item moves to the resolved list

### Viewing Resolved Items

1. Click **Show Resolved** at the bottom of the Action Items section
2. You can unresolve items if needed

### Archiving Old Items

Resolved items can be archived to declutter:

1. Show resolved items
2. Click **Archive** on items you want to hide

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| **Ctrl/Cmd + K** | Open command bar |
| **Escape** | Close modal/command bar |
| **Enter** | Send message (in command bar) |
| **Shift + Enter** | New line in message |

---

## Troubleshooting

### Agent Not Spawning

**Symptoms:** Moving task to "In Progress" doesn't spawn an agent.

**Solutions:**

1. Check if OpenClaw is running: `openclaw status`
2. Verify `OPENCLAW_TOKEN` is set in `.env`
3. Check the agent is configured in OpenClaw
4. Look at the backend logs for errors

### Command Bar Not Responding

**Symptoms:** Messages sent but no response.

**Solutions:**

1. Check if OpenClaw gateway is accessible
2. Verify the session is still active
3. Try switching to a different session
4. Check browser console for WebSocket errors

### Tasks Not Updating

**Symptoms:** Changes don't appear on other devices.

**Solutions:**

1. Check WebSocket connection (refresh page)
2. Verify you're connected to the same server
3. Check for JavaScript errors in browser console

### Lost Chat History

**Symptoms:** Command bar history is empty after refresh.

**Solutions:**

1. Chat history is persisted in SQLite
2. Check if `data/tasks.db` exists
3. Verify the Docker volume mount is correct

### "Only User can move to Done"

**Symptoms:** Error when agent tries to move task to Done.

**Explanation:** This is by design. Only humans can approve task completion to ensure human oversight of AI work.

**Solution:** You must move the task to Done yourself after reviewing the agent's work.

---

## Tips & Best Practices

### For Effective Task Management

1. **Be specific in descriptions** - Agents work better with clear requirements
2. **Use priorities wisely** - Critical should be rare, High for important work
3. **Check action items regularly** - Agents may have questions
4. **Review before Done** - Always check agent work before approving

### For Better Agent Interactions

1. **Tag the right agent** - Use @mentions to get specialized expertise
2. **Provide context** - Include relevant background in comments
3. **Ask follow-up questions** - Agents can clarify their responses
4. **Use the command bar for quick questions** - Don't need a full task

### For Team Collaboration

1. **Keep tasks small and focused** - Easier for agents to complete
2. **Document decisions in comments** - Creates a record for the team
3. **Use blockers appropriately** - Only when truly blocked
4. **Clear done tasks periodically** - Keep the board focused

---

*Need more help? Check the [API Reference](API_REFERENCE.md) or [Architecture](ARCHITECTURE.md) documentation.*
