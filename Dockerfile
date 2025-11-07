# Start from an official Python image
FROM python:3.11-slim

# Set a working directory
WORKDIR /app

# Prevent Python from writing .pyc files and enable stdout/stderr buffering
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy requirement file and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt || true && \
    pip install --no-cache-dir gunicorn

# Copy application code
COPY . /app

# Expose the port the app runs on
EXPOSE 5000

# Use a non-root user for better security (optional)
# Create and use a user called "appuser"
RUN groupadd -r appuser && useradd -r -g appuser appuser || true
USER appuser

# Run the app with gunicorn
# app:app references the `app` variable in app.py
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]

