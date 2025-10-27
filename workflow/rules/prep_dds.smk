# snakefile for preperation of the the dds
# This will involve a rule for creation of the dds from counts and metadata
# as well as a rule for updating a given preprocessed dds with extra metadata

#TODO: figure out the passing of filepaths from one config file

rule dds_from_counts:
  input:
    counts=f"{config['projdir']}/{config['counts']}",
    meta=f"{config['projdir']}/{config['meta']}",
    formula=f"{config['formula']}"
  output:
    dds=f"{config['projdir']}/{config['resultsdir']}/dds.rds"
  conda:
    "../envs/dds_from_counts.yaml"
  message:
    """--- converting data to DESeq Data Structure ---"""
  log:
    "../../results/prep_dds/dds_from_counts.log", #TODO: consider timestamping logs?
  script:
    "../scripts/counts_to_dds.R"

# some intermediate rule that checks for an existing dds or path to dds from nextflow
# I'm not sure on this implementation but there has to be a way to create a new dds if given a path to a counts file  
# or to read a dds from another location if provided in the config

#HACK: I believe this should just need to be an option for the output from
# the nextflow piepline, so have a seperate input for this
# is the metadata the same location... or do I name it something else to
# ensure there is not confusion....
# It should look the same in both cases

# a rule to append metadata to dds from nextflow pipeline
rule dds_update:
  input:
    nf_dds=f"{config['projdir']}/{config['nf_dds']}",
    meta=f"{config['projdir']}/{config['meta']}",
    formula=f"{config['formula']}"
  output:
    dds=f"{config['projdir']}/{config['resultsdir']}/dds.rds"
  conda:
    "../envs/dds_from_nextflow.yaml"
  message:
    """--- Updating dds with metadata ---"""
  log:
    "../../results/prep_dds/dds_from_nextflow.log",
  script:
    "../scripts/update_dds.R"

