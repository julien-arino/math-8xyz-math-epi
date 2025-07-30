#!/usr/bin/env python3
"""
Script to generate Google Gemini prompts for creating slide images based on lecture topics.
Each prompt will request images with viruses, parasites, and bacteria in various artistic styles.
"""

import os
import re
from collections import defaultdict
from pathlib import Path

def extract_lecture_info():
    """Extract lecture titles and image requirements from Rnw files."""
    script_dir = Path(__file__).parent.absolute()
    slides_dir = script_dir / ".." / "SLIDES"
    slides_dir = slides_dir.resolve()
    
    if not slides_dir.exists():
        raise FileNotFoundError(f"SLIDES directory not found at {slides_dir}")
    
    lecture_info = {}
    
    # Process all Rnw files
    for rnw_file in sorted(slides_dir.glob("L*.Rnw")):
        lecture_num = rnw_file.stem
        
        try:
            with open(rnw_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Extract title from the file
            title_match = re.search(r'\\title\{([^}]+)\}', content)
            title = title_match.group(1) if title_match else "Unknown Topic"
            
            # Clean up title
            title = re.sub(r'\\[a-zA-Z]+\{[^}]*\}', '', title)  # Remove LaTeX commands
            title = re.sub(r'\\[a-zA-Z]+', '', title)  # Remove simple LaTeX commands
            title = title.strip()
            
            # Count different types of slide images needed
            title_images = len(re.findall(r'\\titlepagewithfigure\{FIGS-slides-admin/', content))
            outline_images = len(re.findall(r'\\outlinepage\{FIGS-slides-admin/', content))
            section_images = len(re.findall(r'\\newSectionSlide\{FIGS-slides-admin/', content))
            subsection_images = len(re.findall(r'\\newSubSectionSlide\{FIGS-slides-admin/', content))
            
            total_images = title_images + outline_images + section_images + subsection_images
            
            lecture_info[lecture_num] = {
                'title': title,
                'title_images': title_images,
                'outline_images': outline_images,
                'section_images': section_images,
                'subsection_images': subsection_images,
                'total_images': total_images
            }
            
        except Exception as e:
            print(f"Error processing {rnw_file}: {e}")
    
    return lecture_info

def get_topic_keywords(title):
    """Extract key topic words and suggest artistic styles based on content."""
    title_lower = title.lower()
    
    # Topic-specific keywords for better prompts
    topic_keywords = []
    artistic_styles = []
    
    # Mathematical epidemiology topics
    if any(word in title_lower for word in ['compartmental', 'sir', 'seir', 'model']):
        topic_keywords.extend(['mathematical equations', 'flow charts', 'compartments'])
        artistic_styles.extend(['M.C. Escher', 'Piet Mondrian'])
    
    if any(word in title_lower for word in ['endemic', 'epidemic', 'outbreak']):
        topic_keywords.extend(['spreading disease', 'infection waves', 'population dynamics'])
        artistic_styles.extend(['Edvard Munch', 'Francis Bacon'])
    
    if any(word in title_lower for word in ['vector', 'mosquito', 'tick']):
        topic_keywords.extend(['flying insects', 'mosquitoes', 'disease vectors'])
        artistic_styles.extend(['Henri Rousseau', 'Georgia O\'Keeffe'])
    
    if any(word in title_lower for word in ['water', 'borne', 'cholera']):
        topic_keywords.extend(['water droplets', 'aquatic environment', 'contamination'])
        artistic_styles.extend(['Hokusai', 'Claude Monet'])
    
    if any(word in title_lower for word in ['spatial', 'geography', 'diffusion']):
        topic_keywords.extend(['spreading patterns', 'geographic maps', 'spatial distribution'])
        artistic_styles.extend(['Jackson Pollock', 'Wassily Kandinsky'])
    
    if any(word in title_lower for word in ['network', 'contact', 'social']):
        topic_keywords.extend(['connected networks', 'social interactions', 'web patterns'])
        artistic_styles.extend(['Paul Klee', 'Joan Miró'])
    
    if any(word in title_lower for word in ['stochastic', 'random', 'probability']):
        topic_keywords.extend(['random patterns', 'probability clouds', 'uncertainty'])
        artistic_styles.extend(['Salvador Dalí', 'René Magritte'])
    
    if any(word in title_lower for word in ['age', 'structured', 'demographic']):
        topic_keywords.extend(['age groups', 'generations', 'life cycles'])
        artistic_styles.extend(['Gustav Klimt', 'Pablo Picasso'])
    
    if any(word in title_lower for word in ['metapopulation', 'migration', 'travel']):
        topic_keywords.extend(['movement', 'migration patterns', 'transportation'])
        artistic_styles.extend(['Futurism', 'Umberto Boccioni'])
    
    # Default fallbacks
    if not topic_keywords:
        topic_keywords = ['disease dynamics', 'epidemiological concepts']
    if not artistic_styles:
        artistic_styles = ['Vincent van Gogh', 'Henri Matisse', 'Andy Warhol']
    
    return topic_keywords, artistic_styles

def generate_gemini_prompt(lecture_num, info, image_type, count):
    """Generate a specific Gemini prompt for a lecture and image type."""
    title = info['title']
    topic_keywords, artistic_styles = get_topic_keywords(title)
    
    # Base prompt structure
    base_prompt = f"""Create {count} landscape-oriented image{'s' if count > 1 else ''} for {image_type} slide{'s' if count > 1 else ''} about "{title}" in mathematical epidemiology.

Requirements:
- Landscape orientation (wider than tall)
- Include viruses, bacteria, and/or parasites as main visual elements
- Make them visually engaging and slightly humorous/whimsical
- Suitable for academic presentations
- Topic context: {', '.join(topic_keywords)}

Artistic style suggestions: {', '.join(artistic_styles[:3])}

Visual elements to include:
- Cartoon-style or stylized microorganisms
- {"Mathematical symbols, equations, or graphs" if image_type in ["title page", "section"] else ""}
- {"Clean, organized layout for text overlay" if image_type in ["title page", "outline"] else ""}
- Vibrant but professional colors

Please create {"these images" if count > 1 else "this image"} with variety in composition and style."""

    return base_prompt

def generate_all_prompts():
    """Generate all Gemini prompts for the lecture series."""
    print("Generating Google Gemini prompts for mathematical epidemiology slide images...")
    print("=" * 80)
    
    lecture_info = extract_lecture_info()
    
    # Summary first
    total_lectures = len(lecture_info)
    total_images_needed = sum(info['total_images'] for info in lecture_info.values())
    
    print(f"\nSUMMARY:")
    print(f"- {total_lectures} lectures found")
    print(f"- {total_images_needed} total images needed")
    print(f"- Average {total_images_needed/total_lectures:.1f} images per lecture")
    
    print(f"\nDETAILED PROMPTS BY LECTURE:")
    print("=" * 80)
    
    for lecture_num in sorted(lecture_info.keys()):
        info = lecture_info[lecture_num]
        print(f"\n{lecture_num.upper()}: {info['title']}")
        print("-" * 60)
        print(f"Images needed: {info['total_images']} total")
        print(f"  - Title pages: {info['title_images']}")
        print(f"  - Outline pages: {info['outline_images']}")
        print(f"  - Section slides: {info['section_images']}")
        print(f"  - Subsection slides: {info['subsection_images']}")
        print()
        
        # Generate prompts for each image type
        if info['title_images'] > 0:
            print("🎨 TITLE PAGE PROMPT:")
            print(generate_gemini_prompt(lecture_num, info, "title page", info['title_images']))
            print()
        
        if info['outline_images'] > 0:
            print("📋 OUTLINE PAGE PROMPT:")
            print(generate_gemini_prompt(lecture_num, info, "outline page", info['outline_images']))
            print()
        
        if info['section_images'] > 0:
            print("📑 SECTION SLIDE PROMPT:")
            print(generate_gemini_prompt(lecture_num, info, "section", info['section_images']))
            print()
        
        if info['subsection_images'] > 0:
            print("📄 SUBSECTION SLIDE PROMPT:")
            print(generate_gemini_prompt(lecture_num, info, "subsection", info['subsection_images']))
            print()
        
        print("=" * 60)

def create_batch_prompts():
    """Create simplified batch prompts for efficient generation."""
    print("\n" + "=" * 80)
    print("BATCH PROMPTS FOR EFFICIENT GENERATION")
    print("=" * 80)
    
    lecture_info = extract_lecture_info()
    
    # Group by image type for batch processing
    batch_prompts = {
        'title_pages': [],
        'outline_pages': [],
        'section_slides': [],
        'subsection_slides': []
    }
    
    # Collect all topics for each image type
    for lecture_num, info in lecture_info.items():
        if info['title_images'] > 0:
            batch_prompts['title_pages'].append(f"{info['title']} ({info['title_images']} images)")
        if info['outline_images'] > 0:
            batch_prompts['outline_pages'].append(f"{info['title']} ({info['outline_images']} images)")
        if info['section_images'] > 0:
            batch_prompts['section_slides'].append(f"{info['title']} ({info['section_images']} images)")
        if info['subsection_images'] > 0:
            batch_prompts['subsection_slides'].append(f"{info['title']} ({info['subsection_images']} images)")
    
    # Generate batch prompts
    if batch_prompts['title_pages']:
        print("\n🎨 BATCH PROMPT FOR ALL TITLE PAGES:")
        print(f"""Create title page images for mathematical epidemiology lectures. All images should be:
- Landscape orientation
- Feature cartoon-style viruses, bacteria, and parasites
- Professional but engaging style
- Space for title text overlay
- Artistic styles: van Gogh, Monet, Picasso, Matisse variations

Topics and quantities needed:
{chr(10).join(f"  • {topic}" for topic in batch_prompts['title_pages'])}""")
    
    if batch_prompts['outline_pages']:
        print("\n📋 BATCH PROMPT FOR ALL OUTLINE PAGES:")
        print(f"""Create outline page images for mathematical epidemiology lectures. All images should be:
- Landscape orientation  
- Feature organized/structured microorganisms
- Clean, minimal style for text readability
- Artistic styles: Mondrian, Kandinsky, Klee variations

Topics and quantities needed:
{chr(10).join(f"  • {topic}" for topic in batch_prompts['outline_pages'])}""")
    
    if batch_prompts['section_slides']:
        print("\n📑 BATCH PROMPT FOR ALL SECTION SLIDES:")
        print(f"""Create section slide images for mathematical epidemiology lectures. All images should be:
- Landscape orientation
- Dynamic microorganisms showing activity/interaction
- Bold, eye-catching style
- Artistic styles: Pollock, Warhol, Basquiat, Bacon variations

Topics and quantities needed:
{chr(10).join(f"  • {topic}" for topic in batch_prompts['section_slides'])}""")
    
    if batch_prompts['subsection_slides']:
        print("\n📄 BATCH PROMPT FOR ALL SUBSECTION SLIDES:")
        print(f"""Create subsection slide images for mathematical epidemiology lectures. All images should be:
- Landscape orientation
- Detailed microorganism close-ups or specific scenarios
- Subtle, complementary style
- Artistic styles: Dalí, Magritte, O'Keeffe, Rousseau variations

Topics and quantities needed:
{chr(10).join(f"  • {topic}" for topic in batch_prompts['subsection_slides'])}""")

if __name__ == "__main__":
    generate_all_prompts()
    create_batch_prompts()
