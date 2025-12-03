# 1. Base Image: Use a lightweight Python version
FROM python:3.12-slim

# 2. Set the working directory inside the container
WORKDIR /app

# 3. using uv to manage packages
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/

# 4. Copy dependencie
COPY pyproject.toml .
COPY uv.lock .

# 5. increasing timout so it can install all dependencies
ENV UV_HTTP_TIMEOUT=600

# 6. Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv uv sync --locked

# 7. Copy the rest of your application code
COPY src/ ./src

ENV PATH="/app/.venv/bin:$PATH"

# 8. Expose the port Streamlit uses
EXPOSE 8501

# 9. The command to run the app
# We bind to 0.0.0.0 so the container is accessible from outside

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl --fail http://localhost:8501/_stcore/health
ENTRYPOINT ["streamlit", "run", "QR_app.py", "--server.port=8501", "--server.address=0.0.0.0"]