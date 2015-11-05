## SeaAroundUs API Wrapper
R wrapper for the [Sea Around Us API](https://github.com/SeaAroundUs/sau-web-mt).

The Sea Around Us data are licensed to the public under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License.  
Please read the data use policy described in the DATA_USE file.

This software is free software:  you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.  See the LICENSE file for a full statement of the License.


### Installation

*For Mac we need to get some prerequisites first:*
```bash
$ brew tap homebrew/versions
$ brew install v8-315
$ brew install gdal
```

*Now we can install the seaaroundus package from GitHub:*
```R
install.packages("devtools")
library(devtools)
devtools::install_github("SeaAroundUs/rseaaroundus")
```

### Example usage
```R
# include the helper library
library(seaaroundus)

# list available eezs
listregions('eez')

# get species data for Brazil as a data frame
getcatchdata("eez", 76)

# get top 3 species data for Brazil as a data frame
getcatchdata("eez", 76, limit=3)

# get reporting status data by value for Brazil as a data frame
getcatchdata("eez", 76, measure="value", dimension="reporting-status")

# get species data for Brazil as a chart
getcatchdata("eez", 76, chart=TRUE)

# get map of all eez regions
getregionmap("eez")

# get region map of brazil
getregionmap("eez", 76)
```


### Available parameters
Regions:
* eez
* lme
* rfmo
* fishing-entity

Measures:
* tonnage
* value

Dimensions:
* taxon
* commercialgroup
* functionalgroup
* country
* sector
* catchtype
* reporting-status
