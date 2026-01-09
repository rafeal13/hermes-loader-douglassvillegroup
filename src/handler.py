import runpod
import os
from openai import OpenAI

# Initialize the OpenAI client pointing to the local vLLM server
# Since vLLM mimics OpenAI, we can use the standard library.
client = OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="sk-fake-key" # vLLM requires a key but doesn't validate it locally
)

def handler(job):
    """
    This function processes the incoming job from RunPod.
    Expected Input format: {"prompt": "Your story text here", "instruction": "Edit this..."}
    """
    job_input = job.get("input", {})
    
    # Extract data from the input payload
    story_text = job_input.get("prompt", "")
    system_instruction = job_input.get("instruction", "You are a helpful writing assistant.")
    
    if not story_text:
        return {"error": "No prompt provided in input."}

    try:
        # Call the local vLLM engine
        response = client.chat.completions.create(
            model=os.environ.get("MODEL_NAME"),
            messages=[
                {"role": "system", "content": system_instruction},
                {"role": "user", "content": story_text}
            ],
            temperature=0.7,
            max_tokens=2048
        )
        
        # Extract the edited text
        result_text = response.choices[0].message.content
        return {"result": result_text}

    except Exception as e:
        return {"error": str(e)}

# Start the RunPod serverless worker
if __name__ == "__main__":
    runpod.serverless.start({"handler": handler})
