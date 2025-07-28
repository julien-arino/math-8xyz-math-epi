# Slide Title Extraction Script

This Python script (`extract_slide_titles.py`) automatically extracts title and subtitle information from Rnw files in the SLIDES directory and creates a CSV file with the results.

## Features

- Scans all `.Rnw` files in the `../SLIDES/` directory
- Extracts `\title{}` and `\subtitle{}` content from LaTeX/Rnw files
- Cleans up LaTeX commands to produce readable text
- Creates a CSV file with comprehensive slide information

## Usage

```bash
# Basic usage - creates slides_info.csv
python extract_slide_titles.py

# Or on Windows
py extract_slide_titles.py

# Specify custom output filename
python extract_slide_titles.py --output my_slides.csv

# Verbose output
python extract_slide_titles.py --verbose
```

## Output CSV Columns

The generated CSV file contains the following columns:

- **pdf_filename**: The expected PDF filename (e.g., `L01-course-organisation-and-intro-R-julia.pdf`)
- **title**: The extracted title from `\title{...}` command
- **subtitle**: The extracted subtitle from `\subtitle{...}` command  
- **full_title**: Combined title and subtitle for display purposes
- **rnw_filename**: Original Rnw source filename
- **basename**: Base filename without extension

## LaTeX Command Cleaning

The script automatically cleans up common LaTeX commands:

- `\code{text}` → `` `text` ``
- `\textbf{text}` → `text`
- `\emph{text}` → `text`  
- `\href{url}{text}` → `text`
- `\&` → `&`
- Other LaTeX commands are stripped while preserving their content

## Example Output

```csv
pdf_filename,title,subtitle,full_title,rnw_filename,basename
L01-course-organisation-and-intro-R-julia.pdf,"General information about the course & (brief) Introduction to `R` and `julia`","MATH 8xyz -- Lecture 01","General information about the course & (brief) Introduction to `R` and `julia`: MATH 8xyz -- Lecture 01",L01-course-organisation-and-intro-R-julia.Rnw,L01-course-organisation-and-intro-R-julia
```

## Requirements

- Python 3.6+
- Standard library modules only (no external dependencies)

## Integration with Jekyll/Liquid

The generated CSV can be used to automatically populate slide lists in Jekyll sites or other static site generators that support data files.
