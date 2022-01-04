# post processing functions for fields

Leads <- function(res_dt, conf_opt = NULL){
  
  # prefer company lead
  res_dt[companyname != '', Individual := 'N']
  
  # fill individual last name
  res_dt[Individual == "Y" & `Last Name` == '', `Last Name` := conf_opt$ ]
  
  return(res_dt)
}
