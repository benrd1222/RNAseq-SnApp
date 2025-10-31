# The rule to generate the actual differential expression 2025-10-17 14:34
#
#TODO: I added the write results straight to this one so transfer over any outputs we want
# monitored
rule DESeq_run:
  input:
    dds="results/dds.rds"
  output:
    deds="results/deds.rds",
    res_workable="results/res_workable.rds"
  # params:
    # f"{config['paramname']}/" #TODO: these should relate to the ways in which someone might want DESeq to perform the differential expression
  message:
    """--- Running DESeq2 to generate differential expression --- """
  log:
    "results/DESeq_run/DESeq_run.log",
  script:
    "../scripts/run_DESeq.R"


