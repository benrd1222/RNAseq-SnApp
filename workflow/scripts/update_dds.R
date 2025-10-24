# Load libraries and data
library(DESeq2)

# The data is called dds
load(snakemake@input[['nf_dds']])

meta <- readr::read_delim(snakemake@input[["meta"]])

# append metadata other than the sample names onto the dds for the nextflow pathway
# Works assuming that the first column of meta is the sample names
# and that the output from ncore has not been touched
for(i in 1:ncol(meta)-1){
  dds@colData[,2+i] <- meta[,i]
}

# make sure we reain column names
colnames(dds@colData)[,-c(1,2)] <- colnames(meta[,-1])

#attach the user design
design(dds) <- formula(snakemake@input[["formula"]])

# output
saveRDS(dds, snakemake@output[["dds"]])
