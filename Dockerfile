# --- Stage 1: The Builder ---
# This stage has all the tools needed to compile dependencies.
FROM python:3.12-slim AS builder

# 1. Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/

WORKDIR /app

# 2. Optimization settings
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# 3. Build the virtual environment
# We only need the lock/project files to install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev

# --- Stage 2: The Runner ---
# This is the final image. It starts completely clean!
FROM python:3.12-slim

RUN useradd -m -u 1000 qrappuser

WORKDIR /app


# 4. Copy ONLY the finished virtual environment from the builder
COPY --from=builder --chown=qrappuser:qrappuser /app/.venv /app/.venv

# 5. Copy your application code
COPY --chown=qrappuser:qrappuser . .

# 6. Set the environment to use the virtual environment's tools
ENV PATH="/app/.venv/bin:$PATH"


# 7. Setting up before running by exposing port and switching to nonroot user
EXPOSE 8501
USER qrappuser

# 8. Running the app
ENTRYPOINT ["streamlit", "run", "src/QR_app.py"]
CMD ["--server.port=8501", "--server.address=0.0.0.0"]
