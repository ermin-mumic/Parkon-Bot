FROM python:3.11-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TZ=Europe/Zurich \
    PLAYWRIGHT_BROWSERS_PATH=/root/.cache/ms-playwright

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt && \
    playwright install chromium --with-deps && \
    find /root/.cache -name "ffmpeg" -delete && \
    find /root/.cache -name "*.pak" -not -name "resources.pak" -delete && \
    find /root/.cache -name "libGLESv2.so" -delete && \
    find /root/.cache -name "libvk_swiftshader.so" -delete && \
    find /root/.cache -name "*.zip" -delete && \
    rm -rf /root/.cache/pip /root/.cache/ms-playwright/firefox-* /root/.cache/ms-playwright/webkit-* && \
    rm -rf /root/.cache/ms-playwright/chromium-*/chrome-linux/locales/*

COPY . .

CMD ["python", "-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
