# The rule to generate the actual differential expression 

rule DESeq_run:
  input:
    dds="results/dds.rds"
  output:
    deds="results/deds.rds",
    res_workable="results/res_workable.rds"
  # params:
    # f"{config['paramname']}" 
    # smallest group
    # low count cutoff
    # results comparison override code
  message:
    """--- Running DESeq2 to generate differential expression --- """
  log:
    "results/.logs/DESeq_run.log",
  script:
    "../scripts/run_DESeq.R"

