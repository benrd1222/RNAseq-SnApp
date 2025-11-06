# Load libraries
library(glue)
library(purrr)
library(EnhancedVolcano)

# Read in snakemake inputs ----
res_workable <- snakemake@input[["res_workable.rds"]]
res_workable <- readRDS("results/res_workable.rds")

## Ensure directories exist for saving ----
directories <- c(
  "./results/volcano"
)

if (all(dir.exists(directories)) != TRUE) {
  for (i in 1:length(directories)) {
    if (!dir.exists(directories[i])) {
      dir.create(directories[i], recursive = TRUE)
    }
  }
}

# Volcano Plots ----

volcano_dds <- function(x, y, ...) {
  png(
    glue("results/volcano/{y}_.png"),
    width = 800,
    height = 800,
    units = "px",
    pointsize = 12
  )

  print(EnhancedVolcano(
    x,
    lab = x$mgi_symbol,
    x = "log2FoldChange",
    y = "padj",
    pCutoff = 0.05
  ))
  dev.off()
}

walk2(res_workable, names(res_workable), volcano_dds)

# As of right now there are no outputs to track unless we were to make wildcards
# representing each name of the possible reults comparison combination
#
#TODO:
# May need an intermediate dummy file for rule all to watch to ensure that this
# rule gets run. This also brings up how to make this rule and script execution
# testable
