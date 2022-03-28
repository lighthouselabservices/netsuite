# convert pricing from Netsuite to Shopify
require(data.table)
require(magrittr)

# ---- config ----
pricing_ns_file = "E:/Netsuite/Pricing/CustomerItemPricingResults.csv"
sku_ns_file = "E:/Netsuite/Pricing/Itempricing.csv"

price_result_file = "E:/Netsuite/Pricing/pricing_result.csv"

# ---- load data ----

price_in = fread(pricing_ns_file, check.names = T)
stopifnot(nrow(price_in)>0)
setnames(price_in, "Item.Pricing.Unit.Price", 'wholesale_price')

sku_in = fread(sku_ns_file, check.names = T)
stopifnot(nrow(sku_in)>0)

setnames(sku_in, 'Name', 'sku')

# ---- process data -----

# merge data 
# make unique item name first
res = unique(sku_in, by = 'Display.Name')  %>% merge(price_in, by.x = 'Display.Name', by.y =  'Name', all.x = T,  suffixes = c('.Item', 'Price'))

setcolorder(res, c('sku', 'wholesale_price'))
setorder(res, sku)

# ---- save data ----

fwrite(res, price_result_file)
