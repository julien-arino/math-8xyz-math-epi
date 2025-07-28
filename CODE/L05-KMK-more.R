## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "05"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
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

