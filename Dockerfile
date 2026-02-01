FROM python:3.11-slim-bookworm AS builder

RUN apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libjpeg-dev \
        zlib1g-dev \
        libpng-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/

WORKDIR /app
COPY pyproject.toml uv.lock ./

RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install --no-cache --target /app/packages -r pyproject.toml

RUN mkdir -p /app/libs && \
    cp /usr/lib/*-linux-gnu/libjpeg.so* /app/libs/ && \
    cp /usr/lib/*-linux-gnu/libpng16.so* /app/libs/ && \
    cp /lib/*-linux-gnu/libz.so* /app/libs/

FROM gcr.io/distroless/python3-debian12:nonroot

WORKDIR /app

COPY --from=builder /app/packages /app/packages
COPY --from=builder /app/libs /usr/lib/
COPY --chown=nonroot:nonroot . .

ENV PYTHONPATH="/app/packages"
ENV PATH="/app/packages/bin:$PATH"
ENV STREAMLIT_SERVER_PORT=8501
ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0
ENV STREAMLIT_GLOBAL_DEVELOPMENT_MODE=false
ENV STREAMLIT_SERVER_HEADLESS=true

USER nonroot
EXPOSE 8501

ENTRYPOINT ["/usr/bin/python3", "-m", "streamlit", "run", "src/QR_app.py"]
