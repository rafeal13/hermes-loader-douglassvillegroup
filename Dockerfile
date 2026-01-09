# Base Image: Use official vLLM image to ensure CUDA kernels are pre-compiled
# This avoids hours of compilation time and ensures GPU compatibility.
FROM vllm/vllm-openai:latest

# Metadata
LABEL maintainer="ExpertDeployer"
LABEL description="Hermes 3 Llama 3.1 70B Container for RunPod"

# Set environment variables to prevent interactive prompts during builds
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on

# Install essential system utilities
# git: for cloning if needed
# curl/wget: for health checks
# openssh-server: for debugging access in Pods
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    openssh-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy python requirements and install
# Note: vLLM image already has torch and vllm.
# Only install extra handlers or runpod sdk.
COPY requirements.txt.
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the source code
COPY src/ /app/src/

# Copy the startup script and make it executable
COPY src/start.sh /start.sh
RUN chmod +x /start.sh

# Environment variables that can be overridden at runtime
ENV MODEL_NAME="NousResearch/Hermes-3-Llama-3.1-70B"
ENV HF_TOKEN=""

# Default Command
# This script intelligently decides whether to run as a serverless handler
# or a standalone server based on context.
CMD ["/start.sh"]
