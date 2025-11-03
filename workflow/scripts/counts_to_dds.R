# Load libraries and take in inputs from snake make should look something like this

library(DESeq2)
library(readr)

# Setting up debugging support
log_file <- snakemake@log[[1]]

log <- file(log_file, open = "wt")

# Redirect messages and errors
sink(log, type = "output")
sink(log, type = "message")

print("Starting preperation of dds")

# Read in the data: this is in the form snakemake S4 object

#TODO: check that this works proper

# cleaning and organizing the count dataframe for DESeq
# read_delim uses readrs ability to deal with column names that start with numbers
# but then DESeq2 needs a matrix input with rownames which tibbles don't like
# so we need to convert to data.frame
counts <- readr::read_delim(snakemake@input[["counts"]])
annot_gene_info <- as.data.frame(counts[, 1:4])
counts <- as.data.frame(counts[, -(1:4)])
rownames(counts) <- annot_gene_info[, 3]
counts <- as.matrix(counts)

# cleaning and reading in the metadata
meta <- readr::read_delim(snakemake@input[["meta"]])
meta <- as.data.frame(lapply(meta, as.factor))
rownames(meta) <- meta[, 1]
meta <- meta[, -1]

#TODO: Consider how to deal with releveling factors in the metadata

# Set reference levels for the different covariates

# Grabbing the formula from some config path
formula_path <- snakemake@input[["formula"]]
formula <- formula(readLines(formula_path, n = 1))
print(formula)
print(colnames(counts))
print("-----")
print(rownames(meta))
# rownames and colnames must be in the same order for DESeq so....
counts <- counts[, sort(colnames(counts))]
meta <- meta[sort(rownames(meta)), ]

# Converting our counts and meta matrices into a DESeq compatible dataset
dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = counts,
  colData = meta,
  design = formula
)

saveRDS(dds, snakemake@output[["dds"]])

print("Preperation of dds complete")

# Close out logging
sink(type = "message")
sink(type = "output")
close(log)
