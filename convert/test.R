# test conversion functions
source('global.R')

#  ---- test leads conversion ----

# load source data file
fl_in = "D:/Downloads/leads.csv"
dt_source = fread(fl_in,check.names = T)

# read leads cofigration in YAML from github

conf = GetConfig('leads.yaml')
listviewer::jsonedit(conf)

res_leads <- ConvertFields(dt_in = dt_source, conf = conf)

