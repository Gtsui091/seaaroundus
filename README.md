## Sea Around Us API Wrapper
R wrapper for the [Sea Around Us API](https://github.com/SeaAroundUs/sau-web-mt).

The Sea Around Us data are licensed to the public under a Creative Commons Attribution-NonCommercial-ShareAlike 
    4.0 International Public License.  

Please read the data use policy described in the DATA_USE file.

This software is free software:  you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.  See the LICENSE file for a full statement of the License.

### A note on usage
 
When querying the API, please be respectful of the resources required to provide this data. We recommend you retain the results for each request so you can avoid repeated requests for duplicate information.


### Prerequisites

*Mac via Homebrew*
```bash
$ brew tap homebrew/versions
$ brew install v8-315 gdal
```

*Linux via apt-get*
```bash
$ sudo apt-get install libgdal1-dev libgdal-dev libgeos-c1 libproj-dev
```


### Installation

*via the R prompt*
```R
install.packages("devtools")
devtools::install_github("SeaAroundUs/rseaaroundus")
```


### Example usage
```R
# include the helper library
library(seaaroundus)

# list available eezs
listregions('eez')

# get species data for Brazil as a data frame
catchdata("eez", 76)

# use alternative API environment (available on all functions)
# NOTE: alternative API environments may not always be publically accessible or stable
catchdata("eez", 76, env="qa")

# get top 3 species data for Brazil as a data frame
catchdata("eez", 76, limit=3)

# get reporting status data by value for Brazil as a data frame
catchdata("eez", 76, measure="value", dimension="reporting-status")

# get species data for Brazil as a chart
catchdata("eez", 76, chart=TRUE)

# get map of all eez regions
# NOTE: users on Windows have had some issues drawing region maps
regionmap("eez")

# get region map of brazil
regionmap("eez", 76)

# eez vs high seas percent catch data frame
# NOTE: data not available until SeaAroundUs global paper is released
eezsvshighseas()

# eez vs high seas percent catch graph
eezsvshighseas(chart=TRUE)

# marine trophic index for Brazil as a data frame
marinetrophicindex("eez", 76)

# marine trophic index for Brazil as graph
marinetrophicindex("eez", 76, chart=TRUE)

# get cells for a shape in WKT format
getcells("POLYGON ((-48.177685950413291 15.842380165289299,-48.177685950413291 15.842380165289299,
-54.964876033057919 28.964280991735578,-35.960743801652967 27.606842975206646,-48.177685950413291 
15.842380165289299))")

# get datagrid of cell data for a given year and list of cells
getcelldata(2005, c(89568,90288,89569))
```


### Available parameters
Regions:
* eez
* lme
* rfmo
* eez-bordering
* taxon

Measures:
* tonnage
* value

Dimensions:
* taxon (not available for taxon region)
* commercialgroup
* functionalgroup
* country (fishing country)
* sector
* catchtype
* reporting-status
* eez (only available for eez-bordering and taxon regions)
* highseas (only available for taxon region)
