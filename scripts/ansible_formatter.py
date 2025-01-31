import sys
import os
from ruamel.yaml import YAML, YAMLError

def format_yaml(input_file):
    yaml = YAML()
    yaml.indent(mapping=2, sequence=4, offset=2)

    if not os.path.isfile(input_file):
        print(f"Error: File '{input_file}' not found.", file=sys.stderr)
        sys.exit(1)

    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            data = yaml.load(f)
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.", file=sys.stderr)
        sys.exit(1)
    except PermissionError:
        print(f"Error: Permission denied while accessing '{input_file}'.", file=sys.stderr)
        sys.exit(1)
    except YAMLError as e:
        print(f"Error: Failed to parse YAML in '{input_file}': {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error while reading '{input_file}': {e}", file=sys.stderr)
        sys.exit(1)

    try:
        with open(input_file, 'w', encoding='utf-8') as f:
            yaml.dump(data, f)
    except PermissionError:
        print(f"Error: Permission denied while writing to '{input_file}'.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error while writing '{input_file}': {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python format_yaml.py <input_file>", file=sys.stderr)
        sys.exit(1)

    format_yaml(sys.argv[1])
