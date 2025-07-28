# Slide Compilation Script

This repository includes a bash script `compile_slides.sh` to automatically compile Rnw (R Sweave) files to PDF slides.

## Prerequisites

- **R** with the `knitr` package installed
- **LaTeX** distribution with `pdflatex` command
- **Bash** shell (Git Bash on Windows, or WSL)

To install the required R package:
```r
install.packages("knitr")
```

## Usage

### Compile all Rnw files in the SLIDES directory:
```bash
./compile_slides.sh
```

### Compile specific Rnw files:
```bash
./compile_slides.sh SLIDES/L01-course-organisation-and-intro-R-julia.Rnw
./compile_slides.sh SLIDES/L02-epidemiology-math-epi.Rnw
```

### Compile multiple specific files:
```bash
./compile_slides.sh SLIDES/L01-*.Rnw SLIDES/L02-*.Rnw
```

## What the script does

1. **Checks dependencies**: Verifies that R, pdflatex, and the knitr package are available
2. **Runs knitr**: Converts each `.Rnw` file to a `.tex` file
3. **Compiles LaTeX**: Runs `pdflatex` twice to handle cross-references and bibliography
4. **Cleans up**: Removes temporary files but keeps the original `.Rnw`, generated `.tex`, and final `.pdf` files

## Files kept after compilation

- Original `.Rnw` file
- Generated `.tex` file  
- Final `.pdf` file

## Files removed after compilation

- `.aux`, `.bbl`, `.blg`, `.log`, `.nav`, `.out`, `.snm`, `.toc`, `.vrb`
- `.fls`, `.fdb_latexmk`, `.synctex.gz`, `.figlist`, `.makefile`
- `-concordance.tex` files

## Troubleshooting

- If you get permission errors, make sure the script is executable: `chmod +x compile_slides.sh`
- On Windows, run this in Git Bash or WSL
- If LaTeX compilation fails, check that all required packages are installed in your LaTeX distribution
- If R packages are missing, install them with `install.packages("package_name")` in R
