# Load libraries and data
library(DESeq2)
library(readr)

# The data is called dds
load(snakemake@input[['nf_dds']])

meta <- readr::read_delim(snakemake@input[["meta"]])
meta <- as.data.frame(lapply(meta, as.factor))

#HACK: This is also assuming that the metadata is in the same order of samples as output by nfcore, not a great assumption
# could be better to left_join(.by=rownames)

# append metadata other than the sample names onto the dds for the nextflow pathway
# Works assuming that the first column of meta is the sample names
# and that the output from ncore has not been touched
for (i in 1:ncol(meta) - 1) {
  dds@colData[, 2 + i] <- meta[, i]
}

# make sure we reain column names
colnames(dds@colData)[, -c(1, 2)] <- colnames(meta[, -1])

#attach the user design
formula_path <- snakemake@input[["formula"]]
formula <- formula(readLines(formula_path, n = 1))

design(dds) <- formula

# output
saveRDS(dds, snakemake@output[["dds"]])

#Closing out logging
print("Preperation of dds complete")
