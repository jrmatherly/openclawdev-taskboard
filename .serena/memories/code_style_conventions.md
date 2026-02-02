# Code Style and Conventions

## Python (Backend - app.py)

### General Style
- **PEP 8** compliant with reasonable line lengths
- **Type hints** used in function signatures (List, Optional, Set, etc.)
- **Pydantic v2** models for request/response validation
- **Async/await** for FastAPI endpoints and WebSocket handlers

### Naming Conventions
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAIN_AGENT_NAME`, `STATUSES`)
- **Functions**: snake_case (e.g., `spawn_agent_session`, `get_task_session`)
- **Classes**: PascalCase (e.g., `TaskCreate`, `ConnectionManager`)
- **Variables**: snake_case (e.g., `task_id`, `agent_name`)

### Code Organization (app.py sections)
```python
# =============================================================================
# SECTION_NAME
# =============================================================================
```
Sections are clearly delimited with comment blocks:
1. CONFIG
2. BRANDING
3. SECURITY
4. WEBSOCKET MANAGER
5. DATABASE
6. MODELS
7. APP
8. Individual endpoint sections (TASK ENDPOINTS, COMMENTS, etc.)

### Pydantic Models
- Use `BaseModel` from pydantic
- Use `field_validator` for custom validation
- Optional fields use `Optional[T] = None`

### FastAPI Patterns
- Route decorators: `@app.get()`, `@app.post()`, etc.
- Dependency injection: `Depends(verify_api_key)`
- Response models: `response_model=List[Task]`
- Async endpoints for I/O operations

### Error Handling
- Use `HTTPException` with appropriate status codes
- 404 for not found, 403 for forbidden, 401 for unauthorized
- Return JSON with `detail` field for errors

## JavaScript (Frontend - static/index.html)

### Style
- Vanilla JavaScript (no framework)
- ES6+ features (async/await, arrow functions, template literals)
- Inline `<script>` in single HTML file
- CSS custom properties (CSS variables) for theming

### Naming
- **Functions**: camelCase (e.g., `loadTasks`, `renderBoard`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `AGENT_ICONS`)
- **DOM IDs**: kebab-case in HTML

### Patterns
- WebSocket for real-time updates
- Fetch API for REST calls
- Event delegation for dynamic elements

## Documentation

### Markdown
- Mermaid diagrams for architecture visualization
- Tables for structured information
- Code blocks with language specification

### Docstrings
- Triple-quoted strings for function documentation
- Brief description of purpose
- Used sparingly (code is mostly self-documenting)
