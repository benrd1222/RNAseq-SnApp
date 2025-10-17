# Does it make sense to make this a seperate rule
# This rule would only really be rerun if the DESeq_run.smk was rerun
# and I can't think of another time when it might
# changing the formula would rerun this
# changing a specific config would rerun this

# IF that is true then there is no reason for this to even be a rule, just have running the DESEq2 workflow lead to these outputes by default

