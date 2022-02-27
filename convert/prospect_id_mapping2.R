# Mapping Opportunities to External Prospects

source("global.R")

fl_opportunities = "E:/Netsuite/CopperCRM/opp go live v. 4.csv"

opportunities = fread(fl_opportunities, check.names = T)


# get map of copper id to netsuite internal id

map = opportunities[,.(Title, prospect = entity, externalID, prospectExternalID = ProsperWorks.ID.Prospects)] %>% unique(by = 'externalID')

# save the map
fwrite(map, file =  "E:/Netsuite/ForUpload/Prospect_external_Id_map.csv")


