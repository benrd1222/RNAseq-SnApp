# Rule for creation of PCA

rule name:
  input:
    deds="results/deds.rds"
  ouput:
    PCA="results/PCA.jpg"
# params:
    # f"{config['paramname']}" 
    # color palette
    # interest group
    # ggplot overide code
  message:
    """--- Running ordination and visualizing with PCA ---"""
  log:
    "results/.logs/rule_name.log",
  script:
    "../scripts/make_PCA.R"
