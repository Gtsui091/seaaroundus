library(devtools)
countries <- system.file('countries.topojson')
devtools::use_data(countries, internal=T)
