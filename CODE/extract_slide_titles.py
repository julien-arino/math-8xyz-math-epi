#!/usr/bin/env python3
"""
Script to extract slide titles from Rnw files and create a CSV file.

This script scans all Rnw files in the SLIDES directory, extracts the title
and subtitle from each file, and creates a CSV file with the PDF filename
and title information.

Usage: python extract_slide_titles.py
Output: slides_info.csv
"""

import os
import re
import csv
from pathlib import Path
import argparse


def extract_title_from_rnw(file_path):
    """
    Extract title and subtitle from an Rnw file.
    
    Args:
        file_path (str): Path to the Rnw file
        
    Returns:
        tuple: (title, subtitle) where subtitle may be None
    """
    title = None
    subtitle = None
    
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
            content = file.read()
            
            # Look for \title{...} - be more precise to avoid capturing too much
            title_match = re.search(r'\\title\s*\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}', content, re.MULTILINE)
            if title_match:
                title = title_match.group(1).strip()
                # Clean up LaTeX commands
                title = clean_latex_text(title)
            
            # Look for \subtitle{...} - be more precise
            subtitle_match = re.search(r'\\subtitle\s*\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}', content, re.MULTILINE)
            if subtitle_match:
                subtitle = subtitle_match.group(1).strip()
                # Clean up LaTeX commands
                subtitle = clean_latex_text(subtitle)
                
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        
    return title, subtitle


def clean_latex_text(text):
    """
    Clean LaTeX commands from text while preserving basic formatting.
    
    Args:
        text (str): Text with LaTeX commands
        
    Returns:
        str: Cleaned text
    """
    if not text:
        return text
    
    # Replace common LaTeX commands with their content
    text = re.sub(r'\\code\{([^}]+)\}', r'`\1`', text)  # \code{} -> backticks
    text = re.sub(r'\\textbf\{([^}]+)\}', r'\1', text)  # \textbf{} -> plain text
    text = re.sub(r'\\emph\{([^}]+)\}', r'\1', text)    # \emph{} -> plain text
    text = re.sub(r'\\url\{([^}]+)\}', r'\1', text)     # \url{} -> plain text
    text = re.sub(r'\\href\{[^}]+\}\{([^}]+)\}', r'\1', text)  # \href{url}{text} -> text
    
    # Remove other LaTeX commands (keep the content)
    text = re.sub(r'\\[a-zA-Z]+\{([^}]+)\}', r'\1', text)
    
    # Remove standalone LaTeX commands
    text = re.sub(r'\\[a-zA-Z]+\s*', '', text)
    
    # Clean up LaTeX symbols
    text = text.replace('\\&', '&')  # \& -> &
    text = text.replace('\\%', '%')  # \% -> %
    text = text.replace('\\$', '$')  # \$ -> $
    
    # Clean up whitespace
    text = re.sub(r'\s+', ' ', text)
    text = text.strip()
    
    return text


def find_rnw_files(slides_dir):
    """
    Find all Rnw files in the SLIDES directory.
    
    Args:
        slides_dir (str): Path to the SLIDES directory
        
    Returns:
        list: List of Rnw file paths
    """
    slides_path = Path(slides_dir)
    if not slides_path.exists():
        print(f"SLIDES directory not found: {slides_dir}")
        return []
    
    rnw_files = list(slides_path.glob("*.Rnw"))
    rnw_files.sort()  # Sort for consistent ordering
    
    return rnw_files


def extract_lecture_number_from_rnw(file_path):
    """
    Extract the lecture number from the set-lecture-number code chunk at the beginning of an Rnw file.
    
    Args:
        file_path (str): Path to the Rnw file
        
    Returns:
        str: Lecture number as a zero-padded string (e.g., '01'), or None if not found
    """
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
            for _ in range(20):  # Only scan the first 20 lines for efficiency
                line = file.readline()
                match = re.match(r'lecture_number\s*=\s*"(\d+)"', line)
                if match:
                    return f"{int(match.group(1)):02d}"
    except Exception as e:
        print(f"Error reading {file_path} for lecture number: {e}")
    return None


def create_slides_csv(output_file="slides_info.csv"):
    """
    Create a CSV file with slide information.
    
    Args:
        output_file (str): Output CSV filename
    """
    # Find the repository root (assuming we're in CODE subdirectory)
    script_dir = Path(__file__).parent
    repo_root = script_dir.parent
    slides_dir = repo_root / "SLIDES"
    
    print(f"Scanning for Rnw files in: {slides_dir}")
    
    # Find all Rnw files
    rnw_files = find_rnw_files(slides_dir)
    
    if not rnw_files:
        print("No Rnw files found in SLIDES directory")
        return
    
    print(f"Found {len(rnw_files)} Rnw files")
    
    # Extract information from each file
    slides_info = []
    
    for rnw_file in rnw_files:
        print(f"Processing: {rnw_file.name}")
        
        # Get the corresponding PDF filename
        pdf_filename = rnw_file.stem + ".pdf"
        
        # Extract title and subtitle
        title, subtitle = extract_title_from_rnw(rnw_file)
        
        # Extract lecture number from code chunk at the top of the file
        lecture_number = extract_lecture_number_from_rnw(rnw_file)
        if not lecture_number:
            # fallback to filename if not found
            lecture_num_match = re.search(r'L(\d+)', rnw_file.stem)
            if lecture_num_match:
                lecture_number = f"{int(lecture_num_match.group(1)):02d}"
            else:
                lecture_number = "00"  # Default if no lecture number found
        
        # Create combined title
        if title and subtitle:
            full_title = f"{title}: {subtitle}"
        elif title:
            full_title = title
        else:
            # Fallback to filename-based title
            full_title = rnw_file.stem.replace("-", " ").replace("_", " ").title()
        
        slides_info.append({
            'lecture_number': lecture_number,
            'pdf_filename': pdf_filename,
            'title': title or '',
            'subtitle': subtitle or '',
            'full_title': full_title,
            'rnw_filename': rnw_file.name,
            'basename': rnw_file.stem
        })
        
        print(f"  Title: {title}")
        if subtitle:
            print(f"  Subtitle: {subtitle}")
    
    # Write to CSV file in _data directory
    data_dir = repo_root / "_data"
    data_dir.mkdir(exist_ok=True)  # Create _data directory if it doesn't exist
    output_path = data_dir / output_file
    
    with open(output_path, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['lecture_number', 'pdf_filename', 'title', 'subtitle', 'full_title', 'rnw_filename', 'basename']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        writer.writeheader()
        for slide_info in slides_info:
            writer.writerow(slide_info)
    
    print(f"\nCreated CSV file: {output_path}")
    print(f"Total slides processed: {len(slides_info)}")


def main():
    """Main function with command line argument parsing."""
    parser = argparse.ArgumentParser(description='Extract slide titles from Rnw files and create CSV')
    parser.add_argument('-o', '--output', default='slides_info.csv',
                        help='Output CSV filename (default: slides_info.csv)')
    parser.add_argument('--verbose', '-v', action='store_true',
                        help='Enable verbose output')
    
    args = parser.parse_args()
    
    if args.verbose:
        print("Running in verbose mode")
    
    create_slides_csv(args.output)


if __name__ == "__main__":
    main()
