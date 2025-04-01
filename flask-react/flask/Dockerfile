# Stage 1: Builder
FROM python:3.11-slim as builder

WORKDIR /app

# Install netcat and pip tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    netcat-openbsd \
 && rm -rf /var/lib/apt/lists/*

# Pre-copy just requirements for caching
COPY requirements.txt .

RUN pip install --upgrade pip \
 && pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Final Image
FROM python:3.11-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Copy app code
COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
