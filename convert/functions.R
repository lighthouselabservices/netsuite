# data conversion functions for Netsuite
library(yaml)
library(data.table)
library(stringr)


ConvertFields <- function(dt_in = NULL, conf = NULL){
  if(is.null(dt_in)) return(NULL)
  if(is.null(conf)) return(NULL)
  
  # init results 
  res_dt = data.table(Index = 1:nrow(dt_source))
  
  for(fld in conf){
    
    # get net suite field id
    fld_id = fld$netsuiteId
    
    # create net suite field from copper source field
    if(fld$fieldSource=='field') res_dt[[fld_id]] <- dt_in[[fld$copperField]]
    
    if(is.null(res_dt[[fld_id]])) next
    
    # convert to final format
    if(fld$type == 'text') res_dt[[fld_id]] <- as.character(res_dt[[fld_id]])
    
    # check for allowed values
    allowed_values = fld$allowedValues
    if(is.null(allowed_values)) next
    
    # logic for default value
    # if default value is not specified use the first value
    default_value = fld$default
    if(is.null(default_value)) default_value = allowed_values[1]
    
    # check allowed values and replace with default value if missing
    
    is_allowed  = res_dt[[fld_id]]  %chin% allowed_values
    res_dt[!is_allowed][[fld_id]] <- default_value
    
    # check replacements
    stopifnot(all( res_dt[[fld_id]]  %chin% allowed_values))
  }
  
  # remove index column
  res_dt = res_dt[,-c('Index')]
  
  return(res_dt)
  
}


GetConfig <- function(schema_yaml = NULL){
  if(is.null(schema_yaml)) return(NULL)
  
  conf_yaml = try( yaml::read_yaml(str_glue('https://raw.githubusercontent.com/lighthouselabservices/netsuite/main/schema/{schema_yaml}') ) )
  
  if (class(conf_yaml)=="try-error") return(NULL)
  
  listviewer::jsonedit(conf_yaml)
  conf = conf_yaml[[1]]
  listviewer::jsonedit(conf)
  
  return(conf)
}


