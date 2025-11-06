# Clustering related rules 
# * PCA
# * GSEA
# * ORAs
# * Future rules for integration of single cell data

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

rule GSEA_run:
  input:
    deds="results/deds.rds"
  ouput:
    # do we have an output or rather this is writing several outputs
# params:
    # f"{config['paramname']}" 
  message:
  """--- Running Gene Set Enritchment Analysis ---"""
  log:
    "results/.logs/GSEA_run.log",
  script:
    "../scripts/inverse_rulename.R"

rule ORA_run:
  input:
    deds="results/deds.rds"
  ouput:
    #same question here
# params:
    # f"{config['paramname']}" 
  message:
  """--- Running Overe Representation Anlyses for over and under differentially expressed genes per DESeq results comparison ---"""
  log:
    "results/.logs/rule_name.log",
  script:
    "../scripts/run_ORA.R"
