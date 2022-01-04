# post processing functions for fields

Leads <- function(res_dt, conf_opt = NULL){
  
  # prefer company lead
  res_dt[companyname != '', Individual := 'N']
  
  # fill individual last name and first name
  name_replace = conf_opt$nameDefault
  res_dt[Individual == "Y" & `Last Name` == '', `Last Name` := name_replace ]
  res_dt[Individual == "Y" & `first Name` == '', `first Name` := name_replace ]
  
  return(res_dt)
}
