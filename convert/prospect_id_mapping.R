# Mapping Opportunities to Internal Prospect Ids in Netsuite

source("global.R")

fl_prospects = "E:/Netsuite/ForUpload/Prospects with Internal and Copper ID's.csv"
fl_opportunities = "E:/Netsuite/CopperCRM/conversion-opps for go live v.4.csv"

prospects = fread(fl_prospects, check.names = T)
opportunities = fread(fl_opportunities, check.names = T)

prospect_ids = data.table(prospectId = unique(opportunities$ProsperWorks.ID.Prospects))

# get map of copper id to netsuite internal id

map = prospects[,.(Copper.ID, Internal.ID)] %>% unique()

# save the map
fwrite(map, file =  "E:/Netsuite/ForUpload/Prospect_Id_map.csv")


# add internal ids to opportunities

res = opportunities %>%
  merge(map, by.x = "ProsperWorks.ID.Prospects", by.y = "Copper.ID")

fl_res = paste0("E:/Netsuite/ForUpload/",tools::file_path_sans_ext(basename(fl_opportunities) ), "_MAPPED.csv")

fwrite(res, fl_res) 
names(res)

message(str_glue('Result file name: {fl_res} . Number of original opportunities {nrow(opportunities)} . Number of mapped opportunities {nrow(res)} '))

