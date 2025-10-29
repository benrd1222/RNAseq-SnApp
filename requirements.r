BiocManager::install("DESeq2")
BiocManager::install("org.Mm.eg.db")
BiocManager::install("biomaRt")
# as the rocker/rstudio image that this bioconductor image is built comes with tidyverse install I don't need to worry about installing anything other than the bioconductor packages
