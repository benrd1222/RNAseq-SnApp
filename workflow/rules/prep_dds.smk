# snakefile for preperation of the the dds
# This will involve a rule for creation of the dds from counts and metadata
# as well as a rule for updating a given preprocessed dds with extra metadata

rule dds_from_counts:
  input:
    counts=#path_to_file.yaml,
    meta="#path_to_file.yaml"
  output:
    dds="../../results/dds.rds",
  conda:
    "../envs/dds_from_counts.yaml"
  message:
    """--- converting data to DESeq Data Structure ---"""
  log:
    "../../results/prep_dds/dds_from_counts.log",
  script:
    "../scripts/counts_to_dds.R"

# some intermediate rule that checks for an existing dds or path to dds from nextflow
# I'm not sure on this implementation but there has to be a way to create a new dds if given a path to a counts file  
# or to read a dds from another location if provided in the config

# a rule to append metadata to dds from nextflow pipeline
rule dds_update:
  input:
    dds="../../results/dds.rds",
    meta="#path_to_file.yaml"
  output:
    dds="../../results/dds.rds",
  conda:
    "../envs/dds_from_nextflow.yaml"
  message:
    """--- Updating dds with metadata ---"""
  log:
    "../../results/prep_dds/dds_from_nextflow.log",
  script:
    "../scripts/update_dds.R"

