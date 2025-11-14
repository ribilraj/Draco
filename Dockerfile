FROM python:3.11-slim-bullseye

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install Debian dependencies (FIXED)
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    make \
    cmake \
    ffmpeg \
    aria2 \
    libffi-dev \
    build-essential \
    wget \
    unzip

# Install Bento4 (mp4decrypt)
RUN wget -q https://github.com/axiomatic-systems/Bento4/archive/v1.6.0-639.zip && \
    unzip v1.6.0-639.zip && \
    cd Bento4-1.6.0-639 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cp mp4decrypt /usr/local/bin/ && \
    cd ../.. && \
    rm -rf Bento4-1.6.0-639 v1.6.0-639.zip

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Final CMD
CMD ["sh", "-c", "gunicorn app:app & python3 main.py"]
