#!/bin/bash

# Script to compile Rnw files to PDF slides
# Usage: ./compile_slides.sh [file.Rnw] or ./compile_slides.sh (for all Rnw files)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if required tools are available
check_dependencies() {
    print_status "Checking dependencies..."
    
    if ! command -v R &> /dev/null; then
        print_error "R is not installed or not in PATH"
        exit 1
    fi
    
    if ! command -v pdflatex &> /dev/null; then
        print_error "pdflatex is not installed or not in PATH"
        exit 1
    fi
    
    # Check if knitr package is available in R
    if ! R --slave -e "library(knitr)" &> /dev/null; then
        print_error "knitr package is not available in R"
        print_status "Install it with: install.packages('knitr')"
        exit 1
    fi
    
    print_status "All dependencies are available"
}

# Function to compile a single Rnw file
compile_rnw() {
    local rnw_file="$1"
    local basename=$(basename "$rnw_file" .Rnw)
    local dirname=$(dirname "$rnw_file")
    
    print_status "Processing $rnw_file..."
    
    # Change to the directory containing the Rnw file
    cd "$dirname" || {
        print_error "Cannot change to directory $dirname"
        return 1
    }
    
    # Step 1: Run knitr to convert Rnw to tex
    print_status "Running knitr on $basename.Rnw..."
    R --slave -e "library(knitr); knit('$basename.Rnw')" &> /dev/null
    
    if [ ! -f "$basename.tex" ]; then
        print_error "knitr failed to produce $basename.tex"
        return 1
    fi
    
    # Step 2: Compile LaTeX to PDF (run twice for references)
    print_status "Compiling LaTeX to PDF..."
    pdflatex -interaction=batchmode "$basename.tex" &> /dev/null
    
    if [ -f "$basename.aux" ]; then
        # Run pdflatex again for cross-references, bibliography, etc.
        pdflatex -interaction=batchmode "$basename.tex" &> /dev/null
    fi
    
    # Check if PDF was created successfully
    if [ ! -f "$basename.pdf" ]; then
        print_error "PDF compilation failed for $basename"
        return 1
    fi
    
    # Step 3: Clean up temporary files
    print_status "Cleaning up temporary files..."
    
    # List of temporary file extensions to remove
    temp_extensions=("aux" "bbl" "blg" "log" "nav" "out" "snm" "toc" "vrb" "fls" "fdb_latexmk" "synctex.gz" "figlist" "makefile" "concordance.tex")
    
    for ext in "${temp_extensions[@]}"; do
        if [ -f "$basename.$ext" ]; then
            rm "$basename.$ext"
            print_status "Removed $basename.$ext"
        fi
    done
        
    print_status "Successfully compiled $basename.Rnw -> $basename.pdf"
    
    # Return to original directory
    cd - > /dev/null
    
    return 0
}

# Main script logic
main() {
    print_status "Starting Rnw compilation script"
    
    # Check dependencies first
    check_dependencies
    
    # Change to SLIDES directory
    if [ ! -d "SLIDES" ]; then
        print_error "SLIDES directory not found. Run this script from the repository root."
        exit 1
    fi
    
    # Store original directory
    original_dir=$(pwd)
    
    if [ $# -eq 0 ]; then
        # No arguments - process all Rnw files in SLIDES directory
        print_status "Processing all Rnw files in SLIDES directory..."
        
        rnw_files=$(find SLIDES -name "*.Rnw" -type f)
        
        if [ -z "$rnw_files" ]; then
            print_warning "No Rnw files found in SLIDES directory"
            exit 0
        fi
        
        success_count=0
        total_count=0
        
        while IFS= read -r rnw_file; do
            total_count=$((total_count + 1))
            if compile_rnw "$rnw_file"; then
                success_count=$((success_count + 1))
            fi
            echo # Empty line for readability
        done <<< "$rnw_files"
        
        print_status "Compilation complete: $success_count/$total_count files processed successfully"
        
    else
        # Process specific file(s)
        for rnw_file in "$@"; do
            if [ ! -f "$rnw_file" ]; then
                print_error "File not found: $rnw_file"
                continue
            fi
            
            if [[ "$rnw_file" != *.Rnw ]]; then
                print_error "File is not an Rnw file: $rnw_file"
                continue
            fi
            
            compile_rnw "$rnw_file"
            echo # Empty line for readability
        done
    fi
    
    # Return to original directory
    cd "$original_dir"
    
    # Update slides CSV data file
    print_status "Updating slides data file..."
    if command -v python3 &> /dev/null; then
        python_cmd="python3"
    elif command -v python &> /dev/null; then
        python_cmd="python"
    elif command -v py &> /dev/null; then
        python_cmd="py"
    else
        print_warning "Python not found. Skipping slides data file update."
        print_status "Script completed"
        return
    fi
    
    if [ -f "CODE/extract_slide_titles.py" ]; then
        cd CODE
        $python_cmd extract_slide_titles.py --output slides.csv
        if [ $? -eq 0 ]; then
            print_status "Successfully updated slides data file"
        else
            print_warning "Failed to update slides data file"
        fi
        cd "$original_dir"
    else
        print_warning "extract_slide_titles.py not found in CODE directory"
    fi
    
    print_status "Script completed"
}

# Run main function with all arguments
main "$@"
