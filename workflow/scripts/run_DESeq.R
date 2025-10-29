# Load libraries and data

library(DESeq2)
library(dplyr)
library(tidyr)
library(purrr)
library("org.Mm.eg.db")
library("biomaRt")

dds <- readRDS(snakemake@input[["dds"]])

# Run DESeq2 ------
#TODO: add snakemake@Extra_Params_from_config that will hold defaults that can 
# optionally be changed

smallestGroupSize <- 5 
dds <- dds[rowSums(counts(dds) >= 10) >= smallestGroupSize, ]

deds <- DESeq(dds)


# Extracting results ----
# extract all possible combination of results names to compare then 
# walk applying each combination

results_deds_names <- resultsNames(deds)[-(resultsNames(deds) == "Intercept")]

res_list <- map(results_deds_names, ~ results(deds, name = .x))

names(res_list) <- results_deds_names

# Mapping annotations to genes
#TODO: Make a more streamlined mapping of a set of annotation to each MGI in our
# actual data set
ensembl <- biomaRt::useEnsembl(biomart = "genes", dataset = "mmusculus_gene_ensembl")
listensembl <- biomaRt::useEnsembl(biomart = "genes")

gene_annotations <- biomaRt::getBM(
  attributes = c(
    "ensembl_gene_id",
    "mgi_symbol",
    "description",
    "chromosome_name"
  ),
  filters = "mgi_symbol",
  values = rownames(as.data.frame(res_list[[1]])),
  mart = ensembl
)
rm(ensembl, listensembl)
gc()

# Now we map back the found descriptions to the genes
#
# We would also like to keep the chromosome location so as to be able to filter
# out X Y chromosomes due to potentially imbalanced designs related to mouse
# sex, this will be a seperate switchable action that will merge with chromosome
# column and filter by not X or Y
mgi_df <- data.frame(
  'mgi_symbol' = rownames(as.data.frame(res_list[[1]]))
)
genes_annot <- full_join(mgi_df, gene_annotations, by = "mgi_symbol") |>
  group_by(mgi_symbol) |>
  summarise(
    CombinedDescription = paste(description, collapse = "; ")
  ) |>
  ungroup()

#TODO: Functionality of xy chromosome filter- need to also make this dependent on snakemake@params
if (rm_xy == TRUE) {
  genes_annot <- genes_annot |>
    filter(chromosome_name != X | chromosome_name != Y)
}

genes_annot <- as.data.frame(genes_annot)
rownames(genes_annot) <- genes_annot$mgi_symbol

# raw
paths <- paste0("../../results/runDESeq/data/", results_deds_names, ".csv")
tmp <- map(
  res_list,
  ~ merge(as.data.frame(.x), genes_annot, by = 'row.names', all = FALSE)
)
walk2(tmp, paths, write.csv)
mgi_df <- merge(
  as.data.frame(res_list[[1]]),
  genes_annot,
  by = 'row.names',
  all = FALSE
)

#filtered
res_list_filtered <- map(res_list, ~ .x[.x$padj < 0.05 & !is.na(.x$padj), ])

tmp <- map(
  res_list_filtered,
  ~ merge(as.data.frame(.x), genes_annot, by = 'row.names', all = FALSE)
)

paths_filtered <- glue(
  "../../results/runDESeq/data/{results_deds_names}_filtered_padj05.csv"
)

walk2(tmp, paths_filtered, write.csv)


# summary of filtered

summarize_deds_res <- function(x, y) {
  sink(glue("../../results/runDESeq/data/{y}_filtered_summary.txt"))
  print(summary(x))
  sink()
}

walk2(res_list_filtered, results_deds_names, summarize_deds_res)

# Making the results into filtered, ordered, and annotated dataframes
cutoff <- 1
res_workable <- list()
for (i in 1:length(res_list_filtered)) {
  tmp <- as.data.frame(res_list_filtered[[i]])
  tmp <- merge(tmp, genes_annot, by = 'row.names', all = FALSE)

  tmp <- tmp |>
    mutate(
      dir = case_when(
        log2FoldChange > cutoff ~ "UP",
        log2FoldChange < -1 * cutoff ~ "DOWN",
        T ~ "NS"
      )
    ) |>
    arrange(desc(log2FoldChange))

  res_workable[[i]] <- tmp
}

names(res_workable) <- results_deds_names

#Need any outputs for visualization attached here
saveRDS(res_workable, snakemake@output[["res_workable"]])
