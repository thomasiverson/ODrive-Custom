#!/usr/bin/env python3
"""
Search for C++ symbols in the ODrive firmware codebase.

Usage:
    python search_symbol.py Motor::update
    python search_symbol.py "ERROR_*" --regex
    python search_symbol.py Encoder --type class
"""

import argparse
import subprocess
import sys
from pathlib import Path
import re

def find_firmware_dir():
    """Find the Firmware directory relative to script location."""
    script_dir = Path(__file__).parent
    repo_root = script_dir.parent.parent.parent
    firmware_dir = repo_root / 'Firmware'
    
    if not firmware_dir.exists():
        print(f"❌ Error: Firmware directory not found at {firmware_dir}")
        sys.exit(1)
    
    return firmware_dir

def search_symbol(firmware_dir, symbol, use_regex=False, symbol_type=None):
    """Search for a symbol in the codebase."""
    
    print(f"🔍 Searching for: {symbol}")
    if use_regex:
        print("   (using regex pattern)")
    if symbol_type:
        print(f"   (type: {symbol_type})")
    print()
    
    # Build grep command
    grep_args = ['grep', '-rn']
    
    if use_regex:
        grep_args.extend(['-E'])
    else:
        grep_args.extend(['-F'])  # Fixed string
    
    # Add symbol type patterns
    if symbol_type == 'class':
        pattern = f"class\\s+{symbol}"
        grep_args.extend(['-E', pattern])
    elif symbol_type == 'function':
        pattern = f"{symbol}\\s*\\("
        grep_args.extend(['-E', pattern])
    elif symbol_type == 'variable':
        pattern = f"\\b{symbol}\\b"
        grep_args.extend(['-E', pattern])
    else:
        grep_args.append(symbol)
    
    # Search in relevant directories
    search_dirs = ['MotorControl', 'communication', 'Board']
    
    results = []
    for search_dir in search_dirs:
        dir_path = firmware_dir / search_dir
        if not dir_path.exists():
            continue
        
        try:
            result = subprocess.run(
                grep_args + [str(dir_path)],
                capture_output=True,
                text=True
            )
            
            if result.stdout:
                results.extend(result.stdout.split('\n'))
        except subprocess.CalledProcessError:
            pass  # No results in this directory
    
    # Display results
    if not results or all(not r for r in results):
        print(f"❌ No results found for '{symbol}'")
        return False
    
    print(f"✅ Found {len([r for r in results if r])} occurrences:\n")
    
    for result in results:
        if not result:
            continue
        
        # Parse result: filename:line:content
        parts = result.split(':', 2)
        if len(parts) >= 3:
            filepath = parts[0]
            line_num = parts[1]
            content = parts[2].strip()
            
            # Make filepath relative to Firmware dir
            try:
                rel_path = Path(filepath).relative_to(firmware_dir)
            except ValueError:
                rel_path = filepath
            
            print(f"📁 {rel_path}:{line_num}")
            print(f"   {content}\n")
    
    return True

def main():
    parser = argparse.ArgumentParser(
        description='Search for C++ symbols in ODrive firmware'
    )
    parser.add_argument(
        'symbol',
        help='Symbol to search for (class name, function, variable, etc.)'
    )
    parser.add_argument(
        '--regex',
        action='store_true',
        help='Treat symbol as regex pattern'
    )
    parser.add_argument(
        '--type',
        choices=['class', 'function', 'variable'],
        help='Specify symbol type for more precise search'
    )
    
    args = parser.parse_args()
    
    firmware_dir = find_firmware_dir()
    success = search_symbol(firmware_dir, args.symbol, args.regex, args.type)
    
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
