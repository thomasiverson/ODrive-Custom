#!/usr/bin/env python3
"""
List error codes defined in odrive-interface.yaml

Usage:
    python list_errors.py
    python list_errors.py --filter encoder
    python list_errors.py --format table
"""

import argparse
import sys
from pathlib import Path
import re

def find_interface_yaml():
    """Find the odrive-interface.yaml file."""
    script_dir = Path(__file__).parent
    repo_root = script_dir.parent.parent.parent
    yaml_file = repo_root / 'Firmware' / 'odrive-interface.yaml'
    
    if not yaml_file.exists():
        print(f"❌ Error: odrive-interface.yaml not found at {yaml_file}")
        sys.exit(1)
    
    return yaml_file

def parse_errors(yaml_file, filter_text=None):
    """Parse error codes from the YAML file."""
    
    errors = []
    in_error_section = False
    current_error = None
    
    with open(yaml_file, 'r') as f:
        for line in f:
            line = line.rstrip()
            
            # Check if we're in an error enum section
            if 'error' in line.lower() and 'enum' in line.lower():
                in_error_section = True
                continue
            
            # Look for error entries (typically indented with ERROR_)
            if in_error_section and 'ERROR_' in line:
                # Extract error name
                match = re.search(r'(ERROR_\w+)', line)
                if match:
                    error_name = match.group(1)
                    
                    # Check filter
                    if filter_text and filter_text.lower() not in error_name.lower():
                        continue
                    
                    # Extract value if present
                    value_match = re.search(r':\s*(\d+)', line)
                    value = value_match.group(1) if value_match else 'auto'
                    
                    errors.append({
                        'name': error_name,
                        'value': value,
                        'line': line
                    })
    
    return errors

def display_errors(errors, format_type='list'):
    """Display errors in specified format."""
    
    if not errors:
        print("❌ No errors found")
        return
    
    print(f"\n📋 Found {len(errors)} error codes:\n")
    
    if format_type == 'table':
        # Table format
        print(f"{'Error Code':<50} {'Value':<10}")
        print("-" * 60)
        for error in errors:
            print(f"{error['name']:<50} {error['value']:<10}")
    else:
        # List format
        for error in errors:
            print(f"  • {error['name']}")
            if error['value'] != 'auto':
                print(f"    Value: {error['value']}")
            print()

def main():
    parser = argparse.ArgumentParser(
        description='List error codes from odrive-interface.yaml'
    )
    parser.add_argument(
        '--filter',
        help='Filter errors containing this text'
    )
    parser.add_argument(
        '--format',
        choices=['list', 'table'],
        default='list',
        help='Output format'
    )
    
    args = parser.parse_args()
    
    yaml_file = find_interface_yaml()
    errors = parse_errors(yaml_file, args.filter)
    display_errors(errors, args.format)

if __name__ == '__main__':
    main()
