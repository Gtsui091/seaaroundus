## Sea Around Us API Wrapper
R wrapper for the [Sea Around Us API](https://github.com/SeaAroundUs/sau-web-mt).

The Sea Around Us data are licensed to the public under a Creative Commons Attribution-NonCommercial-ShareAlike 
    4.0 International Public License.  

Please read the data use policy described in the DATA_USE file.

This software is free software:  you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.  See the LICENSE file for a full statement of the License.


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
* lme (only available for taxon region)
* highseas (only available for taxon region)
