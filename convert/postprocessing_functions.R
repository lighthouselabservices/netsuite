# post processing functions for fields

Leads <- function(res_dt){
  
  # prefer company lead
  res_dt[companyname != '', Individual := 'N']
  
  # fill individual last name
  
  return(res_dt)
}