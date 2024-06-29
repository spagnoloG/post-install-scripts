import re
import os

def add_newlines(filename):
    with open(filename, 'r') as file:
        content = file.read()
    
    # Add newlines between tasks
    modified_content = re.sub(r'(\n  - name:)', r'\n\1', content)

    with open(filename, 'w') as file:
        file.write(modified_content)

def process_directory(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".yml"):
                filepath = os.path.join(root, file)
                add_newlines(filepath)

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python add_newlines.py <directory>")
    else:
        process_directory(sys.argv[1])
