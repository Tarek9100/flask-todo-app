FROM python:3.8-alpine

# Install system dependencies
RUN apk update && apk add --no-cache \
    build-base \
    postgresql-dev \
    gcc \
    musl-dev \
    linux-headers \
    libffi-dev \
    openssl-dev \
    cargo

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .

# Upgrade pip (optional but recommended)
RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Set environment variables 
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Run the application
CMD ["python", "app.py"]
