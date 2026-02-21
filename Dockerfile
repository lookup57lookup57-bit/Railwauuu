# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for aiohttp and other packages
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    make \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (for better caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy all bot files
COPY *.py .
COPY *.json .
COPY *.txt .

# Create empty JSON files if they don't exist (for first run)
RUN touch banned_users.json free_users.json keys.json premium.json proxy.json user_sites.json cc.txt && \
    echo "{}" > banned_users.json && \
    echo "{}" > free_users.json && \
    echo "{}" > keys.json && \
    echo "{}" > premium.json && \
    echo "{}" > proxy.json && \
    echo "{}" > user_sites.json && \
    echo "" > cc.txt

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV TZ=Asia/Kolkata

# Run the bot
CMD ["python", "bot.py"]
