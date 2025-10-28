# The rule to generate the actual differential expression 2025-10-17 14:34
#
#TODO: I added the write results straight to this one so transfer over any outputs we want
# monitored
rule DESeq_run:
  input:
    dds=f"{config['projdir']}/{config['resultsdir']}/dds.rds"
  output:
    res_workable=f"{config['projdir']}/{config['resultsdir']}/deds.rds"
  # params:
    # f"{config['paramname']}/" #TODO: these should relate to the ways in which someone might want DESeq to perform the differential expression
  conda:
    "../envs/DESeq_run.yaml"
  message:
    """--- Running DESeq2 to generate differential expression --- """
  log:
    "../../results/DESeq_run/DESeq_run.log",
  script:
    "../scripts/run_DESeq.R"


