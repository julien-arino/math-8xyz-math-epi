# CODE directory

This directory contains several files with code. If absent, it will be generated when the Rnw files for the slides are run.

- Files with name patterns L??-*.R are generated when the Rnw files are run. They contain all the `R` code in the corresponding Rnw files.
- compile-slides.sh is a `bash` script that compiles all the Rnw files, then cleans up all temporary LaTeX files generated in the process.
- extract_slide_titles.py is used internally (by compile-slides.sh) to generate a list of the pdf together with the slides titles.