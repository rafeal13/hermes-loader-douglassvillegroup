def format_hermes_prompt(instruction, context):
    """
    Helper to create a formatted prompt specifically for Hermes 3
    if you decide to manually construct prompt strings later.
    """
    return f"""<|im_start|>system
{instruction}<|im_end|>
<|im_start|>user
{context}<|im_end|>
<|im_start|>assistant
"""
