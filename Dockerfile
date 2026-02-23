FROM python:3.12-slim-bookworm

RUN apt-get update && apt-get install -y git

# ── Playwright browsers ───────────────────────────────────────────────────
# Installed BEFORE git clone so this cached layer survives upstream app
# changes. Only re-downloads if the pinned playwright version changes.
RUN pip install --no-cache-dir uv
RUN uv pip install --system --no-cache-dir playwright==1.51.0
RUN playwright install --with-deps

# ── Application ───────────────────────────────────────────────────────────
WORKDIR /app
RUN git clone https://github.com/FoundationAgents/OpenManus.git
WORKDIR /app/OpenManus

# crawl4ai==0.6.3 requires pillow<11; drop the explicit pillow pin
# and let crawl4ai pull in a compatible version (10.x).
RUN sed -i '/^pillow/d' requirements.txt

RUN uv pip install --system --no-cache-dir -r requirements.txt
RUN uv pip install --system --no-cache-dir structlog daytona

CMD ["python", "main.py"]
# CMD ["bash"]
