#!/usr/bin/env python3
"""
Script to analyze FIGS-slides-admin image usage in Rnw files and identify duplications.
"""

import os
import re
from collections import defaultdict, Counter
from pathlib import Path

def extract_image_references(file_path):
    """Extract all FIGS-slides-admin image references from an Rnw file."""
    references = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Find all FIGS-slides-admin references
        pattern = r'FIGS-slides-admin/([^}]+)'
        matches = re.findall(pattern, content)
        
        # Also extract the context (command type)
        for match in re.finditer(r'\\(\w+)\{FIGS-slides-admin/([^}]+)\}', content):
            command = match.group(1)
            image = match.group(2)
            references.append((command, image))
            
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        
    return references

def analyze_usage():
    """Analyze image usage across all Rnw files."""
    # Get the script directory and find SLIDES directory relative to it
    script_dir = Path(__file__).parent.absolute()
    slides_dir = script_dir / ".." / "SLIDES"
    slides_dir = slides_dir.resolve()  # Resolve to absolute path
    
    if not slides_dir.exists():
        raise FileNotFoundError(f"SLIDES directory not found at {slides_dir}")
    
    # Dictionary to store image usage: image_name -> [(file, command), ...]
    image_usage = defaultdict(list)
    
    # Dictionary to store file usage: file -> [(command, image), ...]
    file_usage = defaultdict(list)
    
    # Process all Rnw files
    for rnw_file in slides_dir.glob("*.Rnw"):
        references = extract_image_references(rnw_file)
        file_usage[rnw_file.name] = references
        
        for command, image in references:
            image_usage[image].append((rnw_file.name, command))
    
    return image_usage, file_usage

def print_analysis(image_usage, file_usage):
    """Print detailed analysis of image usage."""
    
    print("=" * 80)
    print("FIGS-SLIDES-ADMIN IMAGE USAGE ANALYSIS")
    print("=" * 80)
    
    # Count total usage
    total_references = sum(len(usage_list) for usage_list in image_usage.values())
    unique_images = len(image_usage)
    
    print(f"\nSUMMARY:")
    print(f"- Total image references: {total_references}")
    print(f"- Unique images used: {unique_images}")
    print(f"- Average references per image: {total_references/unique_images:.1f}")
    
    # Find most used images
    usage_counts = Counter()
    for image, usage_list in image_usage.items():
        usage_counts[image] = len(usage_list)
    
    print(f"\nMOST FREQUENTLY USED IMAGES:")
    print("-" * 50)
    for image, count in usage_counts.most_common(10):
        print(f"{count:3d} uses: {image}")
        # Show where it's used
        for file, command in image_usage[image][:5]:  # Show first 5 uses
            print(f"     {file}: \\{command}")
        if len(image_usage[image]) > 5:
            print(f"     ... and {len(image_usage[image]) - 5} more")
        print()
    
    # Find duplicated images (used more than once)
    duplicated = {img: usage for img, usage in image_usage.items() if len(usage) > 1}
    
    print(f"\nDUPLICATED IMAGES ({len(duplicated)} images used multiple times):")
    print("-" * 60)
    
    # Group by usage count
    by_usage_count = defaultdict(list)
    for image, usage_list in duplicated.items():
        by_usage_count[len(usage_list)].append(image)
    
    for count in sorted(by_usage_count.keys(), reverse=True):
        images = by_usage_count[count]
        print(f"\n{count} USES ({len(images)} images):")
        for image in sorted(images):
            print(f"  {image}")
            for file, command in sorted(image_usage[image]):
                print(f"    - {file}: \\{command}")
    
    # Analyze command types
    command_usage = defaultdict(int)
    for usage_list in image_usage.values():
        for file, command in usage_list:
            command_usage[command] += 1
    
    print(f"\nCOMMAND TYPE USAGE:")
    print("-" * 30)
    for command, count in sorted(command_usage.items(), key=lambda x: x[1], reverse=True):
        print(f"{command:20s}: {count:3d} uses")
    
    # File-by-file breakdown
    print(f"\nFILE-BY-FILE BREAKDOWN:")
    print("-" * 40)
    for file in sorted(file_usage.keys()):
        references = file_usage[file]
        if references:
            print(f"\n{file} ({len(references)} references):")
            for command, image in references:
                uses = len(image_usage[image])
                status = "UNIQUE" if uses == 1 else f"SHARED ({uses} uses)"
                print(f"  \\{command:20s}: {image:30s} [{status}]")

def suggest_optimizations(image_usage):
    """Suggest optimizations to reduce duplication."""
    
    print(f"\n" + "=" * 80)
    print("OPTIMIZATION SUGGESTIONS")
    print("=" * 80)
    
    # Find heavily duplicated images
    heavily_duplicated = {img: usage for img, usage in image_usage.items() if len(usage) > 5}
    
    if heavily_duplicated:
        print(f"\n1. MOST CRITICAL DUPLICATIONS (6+ uses):")
        print("   These images are used very frequently and should be centralized:")
        for image in sorted(heavily_duplicated.keys(), key=lambda x: len(image_usage[x]), reverse=True):
            count = len(image_usage[image])
            print(f"   - {image} ({count} uses)")
    
    # Analyze patterns by command type
    titlepage_images = set()
    outline_images = set()
    section_images = set()
    subsection_images = set()
    
    for image, usage_list in image_usage.items():
        for file, command in usage_list:
            if command == 'titlepagewithfigure':
                titlepage_images.add(image)
            elif command == 'outlinepage':
                outline_images.add(image)
            elif command == 'newSectionSlide':
                section_images.add(image)
            elif command == 'newSubSectionSlide':
                subsection_images.add(image)
    
    print(f"\n2. USAGE BY SLIDE TYPE:")
    print(f"   - Title pages: {len(titlepage_images)} different images")
    print(f"   - Outline pages: {len(outline_images)} different images") 
    print(f"   - Section slides: {len(section_images)} different images")
    print(f"   - Subsection slides: {len(subsection_images)} different images")
    
    # Find images used across multiple slide types
    all_images = titlepage_images | outline_images | section_images | subsection_images
    cross_type_usage = {}
    for image in all_images:
        types = set()
        for file, command in image_usage[image]:
            if command == 'titlepagewithfigure':
                types.add('title')
            elif command == 'outlinepage':
                types.add('outline')
            elif command == 'newSectionSlide':
                types.add('section')
            elif command == 'newSubSectionSlide':
                types.add('subsection')
        if len(types) > 1:
            cross_type_usage[image] = types
    
    if cross_type_usage:
        print(f"\n3. IMAGES USED ACROSS MULTIPLE SLIDE TYPES:")
        print("   Consider using different images for different purposes:")
        for image, types in cross_type_usage.items():
            print(f"   - {image}: {', '.join(sorted(types))}")
    
    print(f"\n4. RECOMMENDED ACTIONS:")
    print("   a) Create a common image pool with semantic naming")
    print("   b) Use one image per slide type (title, outline, section, subsection)")
    print("   c) Consider thematic consistency within lecture series")
    print("   d) Remove unused images from FIGS-slides-admin directory")
    
    # Check for unused images
    script_dir = Path(__file__).parent.absolute()
    figs_dir = script_dir / ".." / "SLIDES" / "FIGS-slides-admin"
    figs_dir = figs_dir.resolve()  # Resolve to absolute path
    
    if figs_dir.exists():
        all_files = set(f.name for f in figs_dir.iterdir() if f.is_file())
        used_files = set(image_usage.keys())
        unused_files = all_files - used_files
        
        if unused_files:
            print(f"\n5. UNUSED IMAGES ({len(unused_files)} files):")
            print("   These images can be removed:")
            for image in sorted(unused_files):
                print(f"   - {image}")
    else:
        print(f"\n5. FIGS-slides-admin directory not found at {figs_dir}")

if __name__ == "__main__":
    print("Analyzing FIGS-slides-admin image usage...")
    image_usage, file_usage = analyze_usage()
    print_analysis(image_usage, file_usage)
    suggest_optimizations(image_usage)
