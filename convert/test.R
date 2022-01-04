# test conversion functions
source("global.R")
#  ---- test leads conversion ----

conversion_type = "Leads"
config = config_options[conversion_type]

# load source data file
fl_in <- "D:/Downloads/leads.csv"
dt_in <- fread(fl_in, check.names = T)

# read leads cofigration in YAML from github

conf_all <- GetConfig("leads.yaml")
listviewer::jsonedit(conf_all)

conf = conf_all$conf
conf_opt = conf_all$options

res_dt <- ConvertFields(dt_in = dt_in, conf = conf)

# post processing functions

PostProcess <- get(conversion_type)

res = PostProcess(res_dt, conf_opt)
