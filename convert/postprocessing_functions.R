# post processing functions for fields

Leads <- function(res_dt, conf_opt = NULL){
  
  # check expected fields present
  expected_fields = c(   "companyname" , "Individual" , "first Name" ,  "Last Name"  )
  if( ! all(expected_fields %in% names(res_dt)) ) return(res_dt)
  
  # prefer company lead
  res_dt[companyname != '', Individual := 'N']
  
  # fill individual last name and first name
  if(is.null(conf_opt)) return(res_dt)
  name_replace = conf_opt$nameDefault
  if(is.null(name_replace)) return(res_dt)
    
  res_dt[Individual == "Y" & `Last Name` == '', `Last Name` := name_replace ]
  res_dt[Individual == "Y" & `first Name` == '', `first Name` := name_replace ]
  
  # remove junk leads
  if("entity status" %in% names(res_dt)){
    
    res_dt = res_dt[! `entity status` %chin% c('Junk', 'Unqualified'),]
    
  }
  
  # sort by date 
  if("custpage_lsa_vis" %in% names(res_dt)){
    
    res_dt[,datesort := as.Date(custpage_lsa_vis, format='%m/%d/%Y')]
    res_dt[is.na(datesort), datesort := (Sys.Date()-10*365)]
    setorder(res_dt, -datesort)
    res_dt[,datesort:=NULL]
    
  }
  
  
  
  # add prefix to leadsource
  if('leadsource' %in% names(res_dt) ){
    
    lead_prefix = conf_opt$sourcePrefix
    if (!is.null(lead_prefix)) res_dt[, leadsource := paste0(lead_prefix, leadsource )]
    
  }
  
  # add unique id
  unique_id_len = conf_opt$idLenght
  res_dt[,uniqueId := paste0(`first Name`, `Last Name`, companyname)%>% str_squish()  ]

  res_dt$uniqueId <- sapply( res_dt$uniqueId, function(x){charToRaw(x) %>% as.character() %>% paste0(collapse = '') %>% str_sub(1, unique_id_len)  }, USE.NAMES = F    )
  
  res_dt = unique(res_dt, by = "uniqueId")
  
  return(res_dt)
}
