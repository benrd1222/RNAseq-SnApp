print("Beginning creation of PCA")

# Load libraries ----
library(DESeq2)
library(ggplot2)
library(tidyverse)

# Read in snakemake inputs ----
deds <- readRDS(snakemake@input[['deds']])

# Clustering -------

# for PCAs we need normalized counts and not LFC
rld_all <- DESeq2::rlog(deds, blind = FALSE)

#rld_all_BLIND <- rlog(deds, blind = TRUE)

#TODO: config params, could be good to add a palette that spans viz rules
# I believe these may all be directly accessible through snakemake@config[['param_name']]
# if I don't want to pass parameters individually

p.top <- 1000
p.intgroup <- "chemo"
p.colorgroup <- "drug"
exp.pointsize <- 5

PCA_plot_all <- DESeq2::plotPCA(
  rld_all,
  intgroup = p.intgroup,
  returnData = TRUE,
  ntop = p.top
)
percentVar <- round(100 * attr(PCA_plot_all, "percentVar"))

#TODO: consider adding gene vectors to the ordination, I think this is a seperate package

# The plot is close enough to good, need to have actual color palettes to have
# anything look better this is true with the legend issue, the legend showing
# the extra meta data will be fixed with a conversion to scale_manual()

PCA_group <- ggplot(
  PCA_plot_all,
  aes(
    x = PC1,
    y = PC2,
    color = .data[[p.colorgroup]],
    group = .data[[p.intgroup]],
    label = .data[[p.intgroup]]
  )
) +
  geom_point(size = exp.pointsize) +
  scale_x_continuous(
    name = paste0("PC1: ", percentVar[1], "% variance")
  ) +
  scale_y_continuous(
    name = paste0("PC2: ", percentVar[2], "% variance")
  ) +
  stat_ellipse(aes(color = .data[[p.intgroup]]), show.legend = FALSE) +
  geom_text(
    data = PCA_plot_all |>
      group_by(.data[[p.intgroup]]) |>
      summarise(PC1 = max(PC1), PC2 = min(PC2)),
    aes(color = .data[[p.intgroup]]),
    position = position_jitter(width = 2, height = 0.5),
    size = 8,
    show.legend = FALSE
  ) +
  ggtitle("PCA") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(
    axis.text = element_text(size = 20),
    axis.title = element_text(size = 25),
    title = element_text(size = 25, face = "bold"),
    legend.text = element_text(size = 20)
  )

ggsave(snakemake@output[['PCA']], plot = PCA_group, width = 15, height = 15)
