#!/bin/bash

echo "FORCE LAUNCHING: NousResearch/Hermes-3-Llama-3.1-70B"

# Set tensor parallelism based on available GPUs (auto-detect)
# But we default to 2 or 4 for safety since you use A100x2 or A6000x4
TP_SIZE=2
if [ -n "$TENSOR_PARALLEL_SIZE" ]; then
    TP_SIZE=$TENSOR_PARALLEL_SIZE
fi

echo "Using Tensor Parallelism: $TP_SIZE"

# Launch vLLM explicitly
python3 -m vllm.entrypoints.openai.api_server \
    --model NousResearch/Hermes-3-Llama-3.1-70B \
    --tensor-parallel-size $TP_SIZE \
    --gpu-memory-utilization 0.95 \
    --port 8000 \
    --host 0.0.0.0 \
    --trust-remote-code
