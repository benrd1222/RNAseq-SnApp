# The rule to generate the actual differential expression 2025-10-17 14:34
# TODO: Consider if write_results.smk needs to exist or just have the written results be part of the output to this rule

rule DESeq_run:
  input:
    "../../results/dds.rds"
  output:
    "../../results/deds.rds"
  params:
    "../../config/Extra_Params_from_config" #TODO: these should relate to the ways in which someone might want DESeq to perform the differential expression
  conda:
    "../envs/DESeq_run.yaml"
  message:
    """--- Running DESeq2 to generate differential expression --- """
  log:
    "../../results/DESeq_run/DESeq_run.log",
  script:
    "../scripts/run_DESeq.R"


