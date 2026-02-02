# Task Completion Checklist

## Before Committing Changes

### Code Quality
- [ ] Code follows project style conventions (PEP 8 for Python)
- [ ] Type hints used for function signatures
- [ ] Pydantic models validate input data
- [ ] Async/await used consistently for I/O operations

### Testing
- [ ] Test API endpoints with curl or browser
- [ ] Verify WebSocket updates work (open two browser tabs)
- [ ] Check Docker container starts successfully
- [ ] Test the specific feature/fix manually

### Security
- [ ] No secrets or API keys in code
- [ ] Input validation in place
- [ ] CORS restrictions maintained
- [ ] API key authentication where required

### Documentation
- [ ] Update docs/PROJECT_INDEX.md if architecture changed
- [ ] Update docs/API_REFERENCE.md if API changed
- [ ] Update docs/openapi.yaml if API changed
- [ ] Update README.md if user-facing features changed

## Commands to Run

```bash
# 1. Check code syntax (Python)
python -m py_compile app.py

# 2. Test Docker build
docker-compose build

# 3. Start and test
docker-compose up -d
curl http://localhost:8080/api/config

# 4. Check for errors in logs
docker-compose logs -f taskboard

# 5. Stop when done testing
docker-compose down
```

## Git Commit Guidelines

### Commit Message Format
```
<type>: <short description>

<optional longer description>

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

### Types
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, no logic change)
- `refactor:` Code refactoring
- `perf:` Performance improvement
- `chore:` Maintenance tasks

### Example
```
feat: Add action item archiving

- Added POST /api/action-items/{id}/archive endpoint
- Added POST /api/action-items/{id}/unarchive endpoint
- Updated frontend to show archive controls
- Added archived column to action_items table

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```
