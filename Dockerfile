FROM python:3.11-slim-bookworm AS builder

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential libjpeg-dev zlib1g-dev libpng-dev


COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install --no-cache --target /app/packages -r pyproject.toml

FROM gcr.io/distroless/python3-debian12:nonroot

WORKDIR /app

COPY --from=builder /app/packages /app/packages
COPY --from=builder /usr/lib/x86_64-linux-gnu/libjpeg.so* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libpng16.so* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /lib/x86_64-linux-gnu/libz.so* /lib/x86_64-linux-gnu/

COPY --chown=nonroot:nonroot . .

ENV PYTHONPATH="/app/packages"
ENV PATH="/app/packages/bin:$PATH"
ENV STREAMLIT_GLOBAL_DEVELOPMENT_MODE=false
ENV STREAMLIT_SERVER_HEADLESS=true

USER nonroot
EXPOSE 8501

ENTRYPOINT ["/usr/bin/python3", "-m", "streamlit", "run", "src/QR_app.py", "--global.developmentMode=false"]
CMD ["--server.port=8501", "--server.address=0.0.0.0"]
