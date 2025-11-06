# Rule for creation of PCA

rule PCA_make:
  input:
    deds="results/deds.rds"
  output:
    PCA="results/PCA.jpg"
  message:
    """--- Running ordination and visualizing with PCA ---"""
  log:
    "results/.logs/PCA_make.log",
  script:
    "../scripts/make_PCA.R"
