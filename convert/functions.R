# data conversion functions for Netsuite
library(yaml)
library(data.table)
library(stringr)


ConvertFields <- function(dt_in = NULL, conf = NULL) {
  if (is.null(dt_in)) {
    return(NULL)
  }
  if (is.null(conf)) {
    return(NULL)
  }

  # init results
  res_dt <- data.table(Index = 1:nrow(dt_in))

  for (fld in conf) {

    # get net suite field id
    fld_id <- fld$netsuiteId
    
    # field value is constant
    if (fld$fieldSource == "const"){
      res_dt[[fld_id]] <- fld$default
      next
    }

    # create net suite field from copper source field
    if (fld$fieldSource == "field") {
      
      add_field = dt_in[[fld$copperField]]
      
      if (is.null(add_field)) next
      
      res_dt[[fld_id]] <- add_field
    } 

    # convert if text
    if (fld$type == "text") {
      res_dt[[fld_id]] <- as.character(res_dt[[fld_id]]) %>% str_squish()
      
    } 
    
    # convert if function
    if (fld$type == "function") {
      
      func = get(fld$fieldSource) # get function
      
      res_dt[[fld_id]] <- as.character( func(dt_in) ) %>% str_squish()
      
    } 
    
    # field not found
    if (is.null(res_dt[[fld_id]])) {
      res_dt[[fld_id]] <- "?"
      next
    }

    # check for allowed values
    allowed_values <- fld$allowedValues
    if (is.null(allowed_values)) next

    # logic for default value
    # if default value is not specified use the first value
    default_value <- fld$default
    if (is.null(default_value)) default_value <- allowed_values[1]

    # check allowed values and replace with default value if missing

    is_allowed <- res_dt[[fld_id]] %chin% allowed_values
    if (!all(is_allowed))  res_dt[!is_allowed][[fld_id]] <- default_value
    
    # check replacements
    stopifnot(all(res_dt[[fld_id]] %chin% allowed_values))
    

    
  }

  # remove index column
  res_dt <- res_dt[, -c("Index")]

  return(res_dt)
}


GetConfig <- function(schema_yaml = NULL) {
  if (is.null(schema_yaml)) {
    return(NULL)
  }

  local_file <- file.path("./data", schema_yaml)

  # remove old file
  if (file.exists(local_file)) file.remove(local_file)

  # download latest file from github
  res_download <- try(download.file(
    url = str_glue("https://raw.githubusercontent.com/lighthouselabservices/netsuite/main/schema/{schema_yaml}"),
    destfile = local_file,
    cacheOK = F
  ))

  if (class(res_download) == "try-error") {
    return(NULL)
  }

  conf_yaml <- try(yaml::read_yaml(local_file))

  if (class(conf_yaml) == "try-error") {
    return(NULL)
  }

  listviewer::jsonedit(conf_yaml)
  
  # field config
  conf <- conf_yaml[[1]]
  listviewer::jsonedit(conf)
  
  #processing options
  opt <- conf_yaml[['options']]
  
  res = list(conf = conf, options = opt)

  return(res)
}

# ---- conversion functions ----

GetBestPhone = function(dt_in){
  if(is.null(dt_in$Phone.Number) ) return(NULL)
  
  # find best phone number
  res = dt_in[,.(Phone.Number, Phone.Number.2, Phone.Number.3)]
  res[Phone.Number == '', Phone.Number := Phone.Number.2]
  res[Phone.Number == '', Phone.Number := Phone.Number.3]
  
  return(res$Phone.Number)
  
}

CombineAddress <- function (dt_in){
  if(is.null(dt_in$Street) ) return(NULL)
  res = dt_in$Street
  
  if(!is.null(dt_in$City) )  res = res %>% paste (dt_in$City)
  if(!is.null(dt_in$State) )  res = res %>% paste (dt_in$State)
  if(!is.null(dt_in$Postal.Code) )  res = res %>% paste (dt_in$Postal.Code)
  if(!is.null(dt_in$Country) )  res = res %>% paste (dt_in$Country)
  
  # cleanup 
  res = str_squish(res)
  
  return(res)
  
}


