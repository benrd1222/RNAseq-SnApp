# snakefile for preperation of the the dds This will involve a rule for creation of the dds from counts and metadata
# as well as a rule for updating a given preprocessed dds with extra metadata

rule dds_from_counts:
  input:
    counts="{config['counts']}",
    meta="{config['meta']}",
    formula="{config['formula']}"
  output:
    dds="results/dds.rds"
# params:
    # f"{config['paramname']}" 
    # mainly parameters for releveling factors in the metadata
  message:
    """--- converting data to DESeq Data Structure ---"""
  log:
    "results/.logs/dds_from_counts.log", #TODO: consider timestamping logs?
  script:
    "../scripts/counts_to_dds.R"

rule dds_update:
  input:
    nf_dds="{config['nf_dds']}",
    meta="{config['meta']}",
    formula="{config['formula']}"
  output:
    dds="results/dds.rds"
# params:
    # f"{config['paramname']}" 
    # Again relevel parameters
  message:
    """--- Updating dds with metadata ---"""
  log:
    "results/.logs/dds_from_nextflow.log",
  script:
    "../scripts/update_dds.R"

