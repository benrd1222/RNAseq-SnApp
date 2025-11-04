# I belive the common rule is where people deal with data verfication and 
# samplesheet verification for bigger workflows

# I am going to use it as a template rule location
# and potentially as the tie together rule for the report generation

# rule name:
#   input:
#     name="{config['results_dir']}"
#   ouput:
#     name="{config['results_dir']}/"
# # params:
#     # f"{config['paramname']}" 
#   message:
#   """--- ---"""
#   log:
#     "{config['results_dir']}/.logs/rule_name.log",
#   script:
#     "../scripts/inverse_rulename.R"
