# test conversion functions
source("global.R")
#  ---- test leads conversion ----

conversion_type = "Leads"
if(conversion_type == 'Prospects') fl_in <-"E:/Netsuite/CopperCRM/prospect for go live.csv"
if(conversion_type == 'Leads')fl_in <-"E:/Netsuite/CopperCRM/leads.csv"
message('Processing ', conversion_type)

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

message(" Max comment: ", max(nchar(res$comments)))
message(" Max phone: ", max(nchar(res$phone)) )


# res = setorder(res, uniqueId)
# 
# res[, ind := cumsum(.N), by=uniqueId]
# 
# dups= res[ind>1, .(`first Name`, `Last Name`, companyname)]
