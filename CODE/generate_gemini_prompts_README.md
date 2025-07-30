# Mathematical Epidemiology Slide Image Analysis Tools

This directory contains Python scripts to analyze and optimize image usage in mathematical epidemiology lecture slides, and to generate AI prompts for creating new slide images.

## 📁 Files Overview

- `analyze_image_usage.py` - Analyzes current image usage and identifies duplications
- `generate_gemini_prompts.py` - Generates Google Gemini prompts for creating new slide images
- `generate_gemini_prompts_README.md` - This documentation file

## 🔍 Image Usage Analysis (`analyze_image_usage.py`)

### Purpose
Analyzes the `FIGS-slides-admin/` directory usage across all Rnw lecture files to identify:
- Duplicated images (same image used multiple times)
- Unused images (files that exist but aren't referenced)
- Usage patterns by slide type (title, outline, section, subsection)
- File-by-file breakdown of image usage

### Usage
```bash
python3 analyze_image_usage.py
```

### Key Findings from Analysis
- **208 total image references** using only **24 unique images**
- **Average 8.7 references per image** (high duplication)
- **Most problematic**: `Gemini_Generated_Image_vqpscpvqpscpvqps.jpeg` used **92 times**
- **41 unused images** taking up space

### Output Sections
1. **Summary Statistics** - Total usage overview
2. **Most Frequently Used Images** - Top 10 most duplicated files
3. **Duplicated Images** - All images used more than once, grouped by usage count
4. **Command Type Usage** - Breakdown by slide type
5. **File-by-File Breakdown** - What each lecture uses
6. **Optimization Suggestions** - Recommended actions
7. **Unused Images** - Files that can be deleted

## 🎨 Gemini Prompt Generation (`generate_gemini_prompts.py`)

### Purpose
Generates ready-to-use Google Gemini prompts for creating new slide images that:
- Feature viruses, bacteria, and parasites as main visual elements
- Are landscape-oriented and suitable for academic presentations
- Include topic-specific artistic style suggestions
- Are engaging but professional

### Usage
```bash
python3 generate_gemini_prompts.py
```

### Features

#### Individual Lecture Prompts
- **27 lectures analyzed** requiring **208 total images**
- Each prompt includes:
  - Specific topic context and keywords
  - 2-3 artistic style suggestions based on content
  - Landscape orientation requirement
  - Professional microorganism theme specifications

#### Smart Topic-to-Style Matching
- **Compartmental models**: M.C. Escher, Piet Mondrian (structured/mathematical)
- **Vector-borne diseases**: Henri Rousseau, Georgia O'Keeffe (nature/insects)
- **Stochastic models**: Salvador Dalí, René Magritte (uncertainty/surreal)
- **Network models**: Paul Klee, Joan Miró (connected patterns)
- **Spatial models**: Jackson Pollock, Wassily Kandinsky (spreading patterns)

#### Batch Prompts for Efficiency
- **Title pages** (27 images) - Professional with space for text overlay
- **Outline pages** (27 images) - Clean, organized style for readability
- **Section slides** (52 images) - Dynamic and eye-catching
- **Subsection slides** (102 images) - Detailed and complementary

### Sample Output
```
🎨 TITLE PAGE PROMPT:
Create 1 landscape-oriented image for title page slide about "Vector-borne diseases" 
in mathematical epidemiology.

Requirements:
- Landscape orientation (wider than tall)
- Include viruses, bacteria, and/or parasites as main visual elements
- Make them visually engaging and slightly humorous/whimsical
- Suitable for academic presentations
- Topic context: flying insects, mosquitoes, disease vectors

Artistic style suggestions: Henri Rousseau, Georgia O'Keeffe

Visual elements to include:
- Cartoon-style or stylized microorganisms
- Mathematical symbols, equations, or graphs
- Clean, organized layout for text overlay
- Vibrant but professional colors
```

## 🚀 Recommended Workflow

### 1. Analyze Current Usage
```bash
python3 analyze_image_usage.py > current_analysis.txt
```
Review the analysis to understand current duplication issues.

### 2. Generate New Image Prompts
```bash
python3 generate_gemini_prompts.py > gemini_prompts.txt
```
Use the prompts with Google Gemini to create new, unique images.

### 3. Optimization Strategy

#### Immediate Actions:
1. **Address the biggest duplicator**: `Gemini_Generated_Image_vqpscpvqpscpvqps.jpeg` (92 uses)
2. **Clean up unused files**: Remove 41 unused images
3. **Create systematic naming**: Use semantic names like `title-epidemic-01.jpeg`

#### Long-term Strategy:
1. **One image per slide type per topic**: Reduce 208 references to ~50-60 unique images
2. **Thematic consistency**: Group related lectures (e.g., L04-L05 KMK models)
3. **Maintain visual variety**: Use the artistic style suggestions for diversity

## 📊 Current Image Requirements by Type

| Slide Type | Count | Purpose |
|------------|-------|---------|
| Title pages | 27 | Professional, space for title text |
| Outline pages | 27 | Clean, organized, readable |
| Section slides | 52 | Dynamic, eye-catching |
| Subsection slides | 102 | Detailed, complementary |
| **Total** | **208** | |

## 🎯 Expected Benefits

After optimization:
- **Unique visual identity** for each lecture topic
- **Reduced file redundancy** (from 24 to ~50-60 unique images)
- **Better thematic organization** with topic-appropriate artistic styles
- **Professional consistency** while maintaining visual interest
- **Cleaner repository** with unused files removed

## 💡 Tips for Using Gemini Prompts

1. **Copy-paste directly** - Prompts are ready to use as-is
2. **Use batch prompts** for efficient generation of similar types
3. **Modify artistic styles** as needed - suggestions are starting points
4. **Request variations** - Ask for 2-3 variations of each image
5. **Save with descriptive names** - Use topic and type in filename

## 🛠 Requirements

- Python 3.6+
- Standard libraries only (no external dependencies)
- Access to the `../SLIDES/` directory containing `.Rnw` files
- Access to the `../SLIDES/FIGS-slides-admin/` directory

## 📝 Output Files

Both scripts output to stdout by default. Redirect to files for permanent records:
```bash
python3 analyze_image_usage.py > analysis_$(date +%Y%m%d).txt
python3 generate_gemini_prompts.py > prompts_$(date +%Y%m%d).txt
```

---

*Created for optimizing mathematical epidemiology lecture slide images*
