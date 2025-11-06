# Rules for volcano plots and potentially heatmaps

rule volcanos_make:
  input:
    name="{config['results_dir']}"
  ouput:
    name="{config['results_dir']}/"
# params:
    # f"{config['paramname']}" 
  message:
  """--- ---"""
  log:
    "{config['results_dir']}/.logs/rule_name.log",
  script:
    "../scripts/make_volcanos.R"
