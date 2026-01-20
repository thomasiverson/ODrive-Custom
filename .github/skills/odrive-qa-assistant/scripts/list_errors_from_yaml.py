#!/usr/bin/env python3
"""
Parse Firmware/odrive-interface.yaml and list error flag definitions.
"""
import sys
import os
import yaml

YAML_PATH = os.path.join(os.path.dirname(__file__), '..', '..', '..', '..', 'Firmware', 'odrive-interface.yaml')

def load_yaml(path):
    with open(path, 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)

def list_errors(data):
    # Traverse the YAML and find 'error' entries with flags
    results = []
    def walk(node, path=''):
        if isinstance(node, dict):
            for k, v in node.items():
                new_path = f"{path}.{k}" if path else k
                if k == 'error' and isinstance(v, dict) and 'flags' in v:
                    flags = v['flags']
                    for flag_name, flag_info in flags.items():
                        if isinstance(flag_info, dict):
                            brief = flag_info.get('brief', '')
                        else:
                            brief = ''
                        results.append((new_path, flag_name, brief))
                else:
                    walk(v, new_path)
        elif isinstance(node, list):
            for idx, item in enumerate(node):
                walk(item, f"{path}[{idx}]")

    walk(data)
    return results

def main():
    if not os.path.exists(YAML_PATH):
        print(f"Could not find {YAML_PATH}")
        sys.exit(1)
    data = load_yaml(YAML_PATH)
    flags = list_errors(data)
    if not flags:
        print("No error flags found in odrive-interface.yaml")
        return
    print("Found error flags:")
    for path, name, brief in flags:
        print(f"- {name} (at {path}): {brief}")

if __name__ == '__main__':
    main()
