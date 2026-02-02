# Development Commands

## Running the Application

### Docker (Recommended)
```bash
# Start the task board
docker-compose up -d

# View logs
docker-compose logs -f taskboard

# Restart after changes
docker-compose restart

# Stop
docker-compose down
```

### Local Development
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # macOS/Linux
# venv\Scripts\activate   # Windows

# Install dependencies
pip install -r requirements.txt

# Run development server
python app.py
# or
uvicorn app:app --reload --host 0.0.0.0 --port 8080
```

## Testing

### API Testing
```bash
# Test API config endpoint
curl http://localhost:8080/api/config

# Test task creation
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Task", "agent": "Architect"}'

# Test WebSocket
websocat ws://localhost:8080/ws
```

### Browser Testing
Open `http://localhost:8080` in browser

## System Commands (Darwin/macOS)

```bash
# Find files
find . -name "*.py" -type f

# Search in code
grep -r "pattern" --include="*.py" .

# List directory
ls -la

# View file
cat filename.py

# Git operations
git status
git diff
git log --oneline -10
```

## Configuration

```bash
# Copy environment template
cp .env.example .env

# Edit configuration
nano .env  # or vim .env

# Required environment variables:
# - OPENCLAW_GATEWAY_URL
# - OPENCLAW_TOKEN
# - TASKBOARD_API_KEY
```

## Docker Management

```bash
# Rebuild container
docker-compose build --no-cache

# Enter container shell
docker exec -it openclaw-dev-taskboard /bin/bash

# View container logs
docker logs openclaw-dev-taskboard

# Check container status
docker ps -a | grep taskboard
```
