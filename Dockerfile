# ---- base image ----
FROM python:3.10-slim

# ---- set a working directory inside the container ----
WORKDIR /app

# ---- copy only requirements first to leverage Docker layer caching ----
COPY requirements.txt ./

# ---- install system dependencies (if any) and python packages ----
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# ---- copy application code and model files into the container ----
COPY . .

# ---- streamlit uses port 8501 by default; expose it (informational) ----
EXPOSE 8501

# ---- default command to run the Streamlit app ----
CMD ["streamlit", "run", "app.py", "--server.port", "8501", "--server.address", "0.0.0.0"]

