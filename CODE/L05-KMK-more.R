## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Load required libraries
required_packages = c("deSolve",
                      "dplyr", 
                      "ggplot2", 
                      "knitr", 
                      "latex2exp",
                      "lattice",
                      "magick",
                      "readr", 
                      "tidyr",
                      "viridis")

for (p in required_packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p, dependencies = TRUE)
    require(p, character.only = TRUE)
  }
}
# Knitr options
opts_chunk$set(echo = TRUE, 
               warning = FALSE, 
               message = FALSE, 
               dev = c("pdf", "png"),
               fig.width = 6, 
               fig.height = 4, 
               fig.path = "FIGS/L05-",
               fig.keep = "high",
               fig.show = "hide")
knitr::knit_hooks$set(crop = knitr::hook_pdfcrop)
options(knitr.table.format = "latex")
# Date for front title page (if needed)
yyyy = strsplit(as.character(Sys.Date()), "-")[[1]][1]


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background?
plot_blackBG = FALSE
if (plot_blackBG) {
  bg_color = "black"
  fg_color = "white"
  input_setup = "\\input{slides-setup-blackBG.tex}"
} else {
  bg_color = "white"
  fg_color = "black"
  input_setup = "\\input{slides-setup-whiteBG.tex}"
}
cat(input_setup)


## ----convert-Rnw-to-R,echo=FALSE,warning=FALSE,message=FALSE,results='hide'----
# From https://stackoverflow.com/questions/36868287/purl-within-knit-duplicate-label-error
rmd_chunks_to_r_temp <- function(file){
  callr::r(function(file, temp){
    out_file = sprintf("../CODE/%s", gsub(".Rnw", ".R", file))
    knitr::purl(file, output = out_file, documentation = 1)
  }, args = list(file))
}
rmd_chunks_to_r_temp("L05-KMK-more.Rnw")

