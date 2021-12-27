# data conversion functions for Netsuite
library(yaml)


# covert leads 

# read leads cofigration in YAML from github
fl = download.file(url = 'https://raw.githubusercontent.com/lighthouselabservices/netsuite/main/schema/leads.yaml', destfile = 'myleads.yaml' )
conf_yaml =  read_yaml('/data/leads.yaml')
cof_leads = conf_yaml$leads

for(fld in conf_leads) print(fld)
