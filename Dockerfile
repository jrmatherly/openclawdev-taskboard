# OpenClaw DEV TaskBoard Dockerfile
# Uses official uv image for fast, reproducible installs

FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Copy dependency files first (for layer caching)
# README.md is needed for hatchling build (pyproject.toml references it)
COPY pyproject.toml uv.lock README.md ./

# Install dependencies using uv sync (reproducible from lockfile)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen

# Copy app
COPY app.py .
COPY static/ static/

# Data volume for SQLite
VOLUME /app/data

# Run
EXPOSE 8080
CMD ["uv", "run", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
