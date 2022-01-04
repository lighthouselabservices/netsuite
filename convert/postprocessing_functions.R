# post processing functions for fields

Leads <- function(res_dt, conf_opt = NULL){
  
  # check expected fields present
  expected_fields = c(   "companyname" , "Individual" , "first Name" ,  "Last Name"  )
  if( ! all(expected_fields %in% names(res_dt)) ) return(res_dt)
  
  # prefer company lead
  res_dt[companyname != '', Individual := 'N']
  
  # fill individual last name and first name
  name_replace = conf_opt$nameDefault
  if(is.null(name_replace)) return(res_dt)
    
  res_dt[Individual == "Y" & `Last Name` == '', `Last Name` := name_replace ]
  res_dt[Individual == "Y" & `first Name` == '', `first Name` := name_replace ]
  
  return(res_dt)
}
