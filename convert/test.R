# test conversion functions
source("global.R")
#  ---- test leads conversion ----

conversion_type = "Prospects"
fl_in <-"E:/Netsuite/CopperCRM/people (15).csv"

#-------
config = config_options[conversion_type]

# load source data file

dt_in <- fread(fl_in, check.names = T)

names_dt_in = data.table(names=names(dt_in))

# read leads cofigration in YAML from github

conf_all <- GetConfig(config)
listviewer::jsonedit(conf_all)

conf = conf_all$conf
conf_opt = conf_all$options

res_dt <- ConvertFields(dt_in = dt_in, conf = conf)

# post processing functions

PostProcess <- try( get(conversion_type) )

if (class(PostProcess) != "try-error") res = PostProcess(res_dt, conf_opt) else res=res_dt


anyDuplicated(res$uniqueId)

# res = setorder(res, uniqueId)
# 
# res[, ind := cumsum(.N), by=uniqueId]
# 
# dups= res[ind>1, .(`first Name`, `Last Name`, companyname)]
