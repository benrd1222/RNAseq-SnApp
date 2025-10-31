# snakefile for preperation of the the dds
# This will involve a rule for creation of the dds from counts and metadata
# as well as a rule for updating a given preprocessed dds with extra metadata

#TODO: figure out the passing of filepaths from one config file

rule dds_from_counts:
  input:
    counts="resources/data_small.csv",
    meta="resources/meta.csv",
    formula="resources/formula.txt"
  output:
    dds="results/dds.rds"
  message:
    """--- converting data to DESeq Data Structure ---"""
  log:
    "results/prep_dds/dds_from_counts.log", #TODO: consider timestamping logs?
  script:
    "../scripts/counts_to_dds.R"

#HACK: I believe this should just need to be an option for the output from
# the nextflow piepline, so have a seperate input for this
# is the metadata the same location... or do I name it something else to
# ensure there is not confusion....
# It should look the same in both cases

# a rule to append metadata to dds from nextflow pipeline
rule dds_update:
  input:
    nf_dds="resources/nf_dds.rds",
    meta="resources/meta.csv",
    formula="resources/formula.txt"
  output:
    dds="results/dds.rds"
  message:
    """--- Updating dds with metadata ---"""
  log:
    "results/prep_dds/dds_from_nextflow.log",
  script:
    "../scripts/update_dds.R"

