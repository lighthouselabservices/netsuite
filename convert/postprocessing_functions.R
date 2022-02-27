# post processing functions for fields

Leads <- function(res_dt, conf_opt = NULL) {

  # check expected fields present
  expected_fields <- c("companyname", "Individual", "first Name", "Last Name")
  if (!all(expected_fields %in% names(res_dt))) {
    return(res_dt)
  }

  # prefer company lead
  res_dt[companyname != "", Individual := "N"]
  
  # limit length of comments
  comment_limit = conf_opt$commentLimit
  res_dt[, comments:= str_sub(comments, 1, comment_limit)]
  
  # limit length of comments
  max_phone_number = conf_opt$maxPhoneLenght
  res_dt[, phone:= str_sub(phone, 1, max_phone_number)] 

  # fill individual last name and first name
  if (is.null(conf_opt)) {
    return(res_dt)
  }
  
  # remove junk leads
  if ("entity status" %in% names(res_dt)) {
    res_dt <- res_dt[!`entity status` %chin% c("Junk", "Unqualified"), ]
  }

  # sort by date
  if ("custpage_lsa_vis" %in% names(res_dt)) {
    res_dt[, datesort := as.Date(custpage_lsa_vis, format = "%m/%d/%Y")]
    res_dt[is.na(datesort), datesort := (Sys.Date() - 10 * 365)]
    setorder(res_dt, -datesort)
    res_dt[, datesort := NULL]
  }

  # add prefix to leadsource
  if ("leadsource" %in% names(res_dt)) {
    lead_prefix <- conf_opt$sourcePrefix
    if (!is.null(lead_prefix)) res_dt[, leadsource := paste0(lead_prefix, leadsource)]
  }
  
  # add prefix to entity status
  if ("entity status" %in% names(res_dt)) {
    lead_prefix <- conf_opt$sourcePrefix
    if (!is.null(lead_prefix)) res_dt[, `entity status` := paste0(lead_prefix, `entity status`)]
  }


  
  name_replace <- conf_opt$nameDefault
  if (is.null(name_replace)) {
    return(res_dt)
  }
  
  res_dt[Individual == "Y" & `Last Name` == "", `Last Name` := name_replace]
  res_dt[Individual == "Y" & `first Name` == "", `first Name` := name_replace]
  
  # add unique id
  unique_id_len <- conf_opt$idLength
  res_dt[, uniqueId := paste0(`first Name`, `Last Name`, companyname) %>% str_squish()]

  res_dt$uniqueId <- sapply(res_dt$uniqueId, function(x) {
    charToRaw(x) %>%
      as.character() %>%
      paste0(collapse = "") %>%
      str_sub(1, unique_id_len)
  }, USE.NAMES = F)

  res_dt <- unique(res_dt, by = "uniqueId")
  

  return(res_dt)
}

#---------------------------

Prospects <- function(res_dt, conf_opt = NULL) {
  
  # check expected fields present
  expected_fields <- c("companyname", "Individual", "first Name", "Last Name")
  if (!all(expected_fields %in% names(res_dt))) {
    return(res_dt)
  }
  
  # prefer company lead
  res_dt[companyname != "", Individual := "N"]
  
  # limit length of comments
  comment_limit = conf_opt$commentLimit
  res_dt[, comments:= str_sub(comments, 1, comment_limit)]
  
  # limit length of comments
  max_phone_number = conf_opt$maxPhoneLenght
  res_dt[, phone:= str_sub(phone, 1, max_phone_number)]  
  
  # fill individual last name and first name
  if (is.null(conf_opt)) {
    return(res_dt)
  }
  
  name_replace <- conf_opt$nameDefault
  if (is.null(name_replace)) {
    return(res_dt)
  }
  
  res_dt[Individual == "Y" & `Last Name` == "", `Last Name` := name_replace]
  res_dt[Individual == "Y" & `first Name` == "", `first Name` := name_replace]
  


  return(res_dt)
}

# --------------

Opportunities <- function(res_dt, conf_opt = NULL) {
  
 
  # limit length of memo
  memo_limit = conf_opt$maxMemo
  res_dt[, memo:= str_sub(memo, 1, memo_limit)]
  
  # limit economics
  economics_limit = conf_opt$maxEconomics
  res_dt[, custbodyproposed_economics:= str_sub(custbodyproposed_economics, 1, economics_limit)]
  
  # change Hot opportunity to T / F
  res_dt[custbodyhot_opportunity=='checked', custbodyhot_opportunity := "T"]
  res_dt[custbodyhot_opportunity=='unchecked', custbodyhot_opportunity := "F"]
  
  return(res_dt)
}

# ------------

# common posts processing functions
CommonPostProcessiing <- function(res_dt){
 
  # clean phone number
  if('phone' %in% names(res_dt)){
    res_dt$phone <- res_dt$phone %>% str_remove_all("'")
  }
  
  return(res_dt)
   
  
}


