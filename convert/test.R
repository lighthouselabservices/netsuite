# test conversion functions
source("global.R")
#  ---- test leads conversion ----

conversion_type = "Leads"
if(conversion_type == 'Prospects') fl_in <-"E:/Netsuite/CopperCRM/prospect for go live.csv"
if(conversion_type == 'Leads')fl_in <-"E:/Netsuite/CopperCRM/leads 200220227.csv"
if(conversion_type == 'Opportunities')fl_in <-"E:/Netsuite/CopperCRM/opp go live v. 4 PRE conversion.csv"

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

# Postprocessing
PostProcess <- try( get(conversion_type) )
if (class(PostProcess) != "try-error") res = PostProcess(res_dt, conf_opt) else res=res_dt

# Common post processing
res <- CommonPostProcessiing(res)

anyDuplicated(res$uniqueId)

if(!is.null(res$comments)) message(" Max comment: ", max(nchar(res$comments)))
if(!is.null(res$phone)) message(" Max phone: ", max(nchar(res$phone)) )
if(!is.null(res$memo)) message(" Max memo: ", max(nchar(res$memo)) )
if(!is.null(res$custbodyproposed_economics)) message(" Max Economics: ", max(nchar(res$custbodyproposed_economics)) )


# If opportunies add external prospect references
if(conversion_type == 'Opportunities'){
  
  map = fread('E:/Netsuite/ForUpload/Prospect_external_Id_map.csv')
  map$externalID <- as.character(map$externalID)
  
  res$externalID <- as.character(res$externalID)
  res = res %>% merge(map[,.(externalID, prospectExternalID)], by = 'externalID')
  
  
}

# save file 
fl_name = paste(conversion_type, "_VK_test.csv")
fwrite(res, file.path("D:/Data", fl_name))

# res = setorder(res, uniqueId)
# 
# res[, ind := cumsum(.N), by=uniqueId]
# 
# dups= res[ind>1, .(`first Name`, `Last Name`, companyname)]
