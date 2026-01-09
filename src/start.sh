#!/bin/bash

echo "Starting vLLM Server for model: $MODEL_NAME..."

# 1. Start vLLM in the background
# --serve-on-start ensures the server is ready before we move on
# We bind to port 8000 so the handler can access it locally
python3 -m vllm.entrypoints.openai.api_server \
    --model $MODEL_NAME \
    --host 0.0.0.0 \
    --port 8000 \
    --tensor-parallel-size 1 \
    &

# Wait for vLLM to start up (loop checks localhost:8000/v1/models)
echo "Waiting for vLLM to become ready..."
while ! curl -s http://localhost:8000/v1/models > /dev/null; do
    sleep 5
done
echo "vLLM is ready!"

# 2. Check execution mode
if [ "$RUNPOD_SERVERLESS" == "true" ]; then
    echo "Starting in Serverless Mode..."
    python3 -u src/handler.py
else
    echo "Starting in Standard Pod Mode..."
    # Keep the container running indefinitely
    sleep infinity
fi
