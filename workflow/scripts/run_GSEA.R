# Load libraries
library(clusterProfiler)
library(tidyverse)
library("org.Mm.eg.db")
#
# Read in snakemake inputs ----
res_workable <- snakemake@input[["res_workable.rds"]]
res_workable <- readRDS("results/res_workable.rds")

## Ensure directories exist for saving ----
directories <- c(
  "./results/GSEA"
)

if (all(dir.exists(directories)) != TRUE) {
  for (i in 1:length(directories)) {
    if (!dir.exists(directories[i])) {
      dir.create(directories[i], recursive = TRUE)
    }
  }
}


# GSEAs -----------
# Need to make a general function out of the following and then pipe in each
# entry in the res_workable list and with its name

p.ont <- "BP" #TODO: replace with snakemake@param//config

# A function to run gseGO and save te output with the option to cahnge the ontology
# of interest
capture_gsea <- function(dat, name, p.ont) {
  dat <- dat |>
    arrange(desc(log2FoldChange))

  list <- dat$log2FoldChange
  names(list) <- rownames(dat)

  gse <- gseGO(
    geneList = list,
    ont = p.ont,
    keyType = "MGI", #TODO: check works, also a good spot to be more flexible, like the key type being attatched to the data somehow or a function to determine available key types
    minGSSize = 3,
    maxGSSize = 800,
    pvalueCutoff = 0.05,
    verbose = TRUE,
    OrgDb = "org.Mm.eg.db",
    pAdjustMethod = "BH",
    seed = TRUE,
    by = "fgsea"
  )

  write.csv(gse@result, str_glue("./results/GSEA/{name}.rds"))

  png(
    str_glue("results/GSEA/{name}.jpg"),
    width = 800,
    height = 800,
    units = "px",
    pointsize = 12
  )
  print(dotplot(gse, showCategory = 15, x = "NES"))
  dev.off()
}

walk2(res_workable, names(res_workable), ~ capture_gsea(.x, .y, p.ont))

# Again no outputs for snakemake unless we decide to make summary file from the
# script. A little read me of what is in the different results fodlers could
# be a good file to make and could be a good file to feed to snakemake to track
# completion of outputs
