# ---------- STEP 1: Use official Python base image ----------
FROM python:3.10-slim

# ---------- STEP 2: Set working directory inside container ----------
WORKDIR /app

# ---------- STEP 3: Copy requirements first (for layer caching) ----------
COPY requirements.txt ./

# ---------- STEP 4: Install dependencies ----------
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# ---------- STEP 5: Copy the rest of your code ----------
COPY . .

# ---------- STEP 6: Expose Streamlit default port ----------
EXPOSE 8501

# ---------- STEP 7: Command to run the Streamlit app ----------
CMD ["streamlit", "run", "app.py", "--server.port", "8501", "--server.address", "0.0.0.0"]
