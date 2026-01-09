# Base image from the official vLLM repository
# This includes pre-compiled CUDA kernels for fast inference
FROM vllm/vllm-openai:latest

# Set the working directory
WORKDIR /app

# Install additional Python dependencies (like the runpod sdk)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY src/ ./src/

# Make the start script executable
RUN chmod +x ./src/start.sh

# Define environment variables (Can be overridden in RunPod UI)
# Default model: Hermes 3 (Llama 3.1 8B version)
ENV MODEL_NAME="NousResearch/Hermes-3-Llama-3.1-8B"
ENV API_KEY="sk-fake-key" 

# The entrypoint script to boot vLLM and the handler
CMD ["./src/start.sh"]
