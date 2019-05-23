seaaroundus
===========


[![cran checks](https://cranchecks.info/badges/worst/seaaroundus)](https://cranchecks.info/pkgs/seaaroundus)
[![cran version](https://www.r-pkg.org/badges/version/seaaroundus)](https://cran.r-project.org/package=seaaroundus)
[![Build Status](https://api.travis-ci.org/ropensci/seaaroundus.svg?branch=master)](https://travis-ci.org/ropensci/seaaroundus)
[![codecov](https://codecov.io/gh/ropensci/seaaroundus/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/seaaroundus)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/seaaroundus)](https://github.com/metacran/cranlogs.app)


## Sea Around Us API Wrapper

R wrapper for the Sea Around Us API.

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

CRAN version


```r
install.packages("seaaroundus")
```

Dev version


```r
install.packages("devtools")
devtools::install_github("ropensci/seaaroundus")
```


```r
library(seaaroundus)
```

### Example usage

list available eezs


```r
head(listregions('eez'))
#>    id                          title
#> 1   8                        Albania
#> 2  12                        Algeria
#> 3  16                 American Samoa
#> 4 357 Andaman & Nicobar Isl. (India)
#> 5  24                         Angola
#> 6 660                  Anguilla (UK)
```

get species data for Brazil as a data frame


```r
head(catchdata("eez", 76))
#>   fao_area_id     sector             scientific_name fishing_entity
#> 1          41  Artisanal                   Abudefduf         Brazil
#> 2          41  Artisanal                   Abudefduf         Brazil
#> 3          41  Artisanal                  Acanthurus         Brazil
#> 4          41  Artisanal                     Achirus         Brazil
#> 5          41 Industrial            Alopias vulpinus         Brazil
#> 6          41  Artisanal Archosargus probatocephalus         Brazil
#>   catch_type year   gear_group      catch landed_value
#> 1   Landings 1950  Small scale 0.03769516     116.8927
#> 2   Landings 1950  Small scale 0.07539033     233.7854
#> 3   Landings 1950  Small scale 7.55222025   31945.8917
#> 4   Landings 1950  Small scale 0.08333333     523.7500
#> 5   Landings 1950 Bottom trawl 0.79096932    2330.9866
#> 6   Landings 1950  Small scale 0.21730483     985.6947
#>                     gear   common_name reporting_status               eez
#> 1   small scale gillnets     Sergeants         Reported Brazil (mainland)
#> 2      small scale lines     Sergeants         Reported Brazil (mainland)
#> 3      small scale lines Surgeonfishes         Reported Brazil (mainland)
#> 4 small scale seine nets         Soles         Reported Brazil (mainland)
#> 5           bottom trawl      Thresher         Reported Brazil (mainland)
#> 6      small scale lines    Sheepshead         Reported Brazil (mainland)
#>   id
#> 1 76
#> 2 76
#> 3 76
#> 4 76
#> 5 76
#> 6 76
```

use alternative API environment (available on all functions)
> NOTE: alternative API environments may not always be publically accessible or stable


```r
head(catchdata("eez", 76, env="qa"))
#>   fao_area_id     sector             scientific_name fishing_entity
#> 1          41  Artisanal                   Abudefduf         Brazil
#> 2          41  Artisanal                   Abudefduf         Brazil
#> 3          41  Artisanal                  Acanthurus         Brazil
#> 4          41  Artisanal                     Achirus         Brazil
#> 5          41 Industrial            Alopias vulpinus         Brazil
#> 6          41  Artisanal Archosargus probatocephalus         Brazil
#>   catch_type year   gear_group      catch landed_value
#> 1   Landings 1950  Small scale 0.03769516     116.8927
#> 2   Landings 1950  Small scale 0.07539033     233.7854
#> 3   Landings 1950  Small scale 7.55222025   31945.8917
#> 4   Landings 1950  Small scale 0.08333333     523.7500
#> 5   Landings 1950 Bottom trawl 0.79096932    2330.9866
#> 6   Landings 1950  Small scale 0.21730483     985.6947
#>                     gear   common_name reporting_status               eez
#> 1   small scale gillnets     Sergeants         Reported Brazil (mainland)
#> 2      small scale lines     Sergeants         Reported Brazil (mainland)
#> 3      small scale lines Surgeonfishes         Reported Brazil (mainland)
#> 4 small scale seine nets         Soles         Reported Brazil (mainland)
#> 5           bottom trawl      Thresher         Reported Brazil (mainland)
#> 6      small scale lines    Sheepshead         Reported Brazil (mainland)
#>   id
#> 1 76
#> 2 76
#> 3 76
#> 4 76
#> 5 76
#> 6 76
```

get top 3 species data for Brazil as a data frame


```r
head(catchdata("eez", 76, limit=3))
#>   fao_area_id     sector             scientific_name fishing_entity
#> 1          41  Artisanal                   Abudefduf         Brazil
#> 2          41  Artisanal                   Abudefduf         Brazil
#> 3          41  Artisanal                  Acanthurus         Brazil
#> 4          41  Artisanal                     Achirus         Brazil
#> 5          41 Industrial            Alopias vulpinus         Brazil
#> 6          41  Artisanal Archosargus probatocephalus         Brazil
#>   catch_type year   gear_group      catch landed_value
#> 1   Landings 1950  Small scale 0.03769516     116.8927
#> 2   Landings 1950  Small scale 0.07539033     233.7854
#> 3   Landings 1950  Small scale 7.55222025   31945.8917
#> 4   Landings 1950  Small scale 0.08333333     523.7500
#> 5   Landings 1950 Bottom trawl 0.79096932    2330.9866
#> 6   Landings 1950  Small scale 0.21730483     985.6947
#>                     gear   common_name reporting_status               eez
#> 1   small scale gillnets     Sergeants         Reported Brazil (mainland)
#> 2      small scale lines     Sergeants         Reported Brazil (mainland)
#> 3      small scale lines Surgeonfishes         Reported Brazil (mainland)
#> 4 small scale seine nets         Soles         Reported Brazil (mainland)
#> 5           bottom trawl      Thresher         Reported Brazil (mainland)
#> 6      small scale lines    Sheepshead         Reported Brazil (mainland)
#>   id
#> 1 76
#> 2 76
#> 3 76
#> 4 76
#> 5 76
#> 6 76
```

get reporting status data by value for Brazil as a data frame


```r
head(catchdata("eez", 76, measure="value", dimension="reporting-status"))
#>   fao_area_id     sector             scientific_name fishing_entity
#> 1          41  Artisanal                   Abudefduf         Brazil
#> 2          41  Artisanal                   Abudefduf         Brazil
#> 3          41  Artisanal                  Acanthurus         Brazil
#> 4          41  Artisanal                     Achirus         Brazil
#> 5          41 Industrial            Alopias vulpinus         Brazil
#> 6          41  Artisanal Archosargus probatocephalus         Brazil
#>   catch_type year   gear_group      catch landed_value
#> 1   Landings 1950  Small scale 0.03769516     116.8927
#> 2   Landings 1950  Small scale 0.07539033     233.7854
#> 3   Landings 1950  Small scale 7.55222025   31945.8917
#> 4   Landings 1950  Small scale 0.08333333     523.7500
#> 5   Landings 1950 Bottom trawl 0.79096932    2330.9866
#> 6   Landings 1950  Small scale 0.21730483     985.6947
#>                     gear   common_name reporting_status               eez
#> 1   small scale gillnets     Sergeants         Reported Brazil (mainland)
#> 2      small scale lines     Sergeants         Reported Brazil (mainland)
#> 3      small scale lines Surgeonfishes         Reported Brazil (mainland)
#> 4 small scale seine nets         Soles         Reported Brazil (mainland)
#> 5           bottom trawl      Thresher         Reported Brazil (mainland)
#> 6      small scale lines    Sheepshead         Reported Brazil (mainland)
#>   id
#> 1 76
#> 2 76
#> 3 76
#> 4 76
#> 5 76
#> 6 76
```

get species data for Brazil as a chart


```r
catchdata("eez", 76, chart=TRUE)
```

eez vs high seas percent catch data frame
> NOTE: data not available until SeaAroundUs global paper is released


```r
head(eezsvshighseas())
#>   year eez_percent_catch high_seas_percent_catch
#> 1 1950                99                       1
#> 2 1951                99                       1
#> 3 1952                99                       1
#> 4 1953                99                       1
#> 5 1954                99                       1
#> 6 1955                99                       1
```

eez vs high seas percent catch graph


```r
eezsvshighseas(chart=TRUE)
```

marine trophic index for Brazil as a data frame


```r
head(marinetrophicindex("eez", 76))
#>   level year
#> 1  3.43 1950
#> 2  3.44 1951
#> 3  3.46 1952
#> 4  3.42 1953
#> 5  3.45 1954
#> 6  3.45 1955
```

marine trophic index for Brazil as graph


```r
marinetrophicindex("eez", 76, chart=TRUE)
```

get cells for a shape in WKT format


```r
wkt <- "POLYGON((2.37 43.56,13.18 43.56,13.18 35.66,2.37 35.66,2.37 43.56))"
res <- getcells(wkt)
res[1:10]
#>  [1] 66605 66606 66607 66608 66609 66610 66611 66612 66613 66614
```

get datagrid of cell data for a given year and list of cells


```r
head(getcelldata(2005, c(89568,90288,89569)))
#>   fishing_entity_id commercial_group_name taxon_scientific_name
#> 1                32     Tuna & billfishes        Kajikia albida
#> 2                32     Tuna & billfishes        Kajikia albida
#> 3                32     Tuna & billfishes        Kajikia albida
#> 4                32     Tuna & billfishes        Thunnus obesus
#> 5                32     Tuna & billfishes        Thunnus obesus
#> 6                32     Tuna & billfishes        Thunnus obesus
#>   reporting_status_name catch_status_name taxon_key   catch_sum
#> 1              Reported          Landings    600219 0.002410807
#> 2              Reported          Landings    600219 0.002339347
#> 3              Reported          Landings    600219 0.002339347
#> 4              Reported          Landings    600146 0.032676598
#> 5              Reported          Landings    600146 0.033773604
#> 6              Reported          Landings    600146 0.032676598
#>   sector_type_name fishing_entity_name reporting_status year
#> 1       Industrial              Taiwan                R 2005
#> 2       Industrial              Taiwan                R 2005
#> 3       Industrial              Taiwan                R 2005
#> 4       Industrial              Taiwan                R 2005
#> 5       Industrial              Taiwan                R 2005
#> 6       Industrial              Taiwan                R 2005
#>   sector_type_id functional_group_name commercial_group_id
#> 1              1             pelagiclg                   4
#> 2              1             pelagiclg                   4
#> 3              1             pelagiclg                   4
#> 4              1             pelagiclg                   4
#> 5              1             pelagiclg                   4
#> 6              1             pelagiclg                   4
#>       taxon_common_name functional_group_id catch_status cell_id
#> 1 Atlantic white marlin                   3            R   90288
#> 2 Atlantic white marlin                   3            R   89568
#> 3 Atlantic white marlin                   3            R   89569
#> 4           Bigeye tuna                   3            R   89569
#> 5           Bigeye tuna                   3            R   90288
#> 6           Bigeye tuna                   3            R   89568
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


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/seaaroundus/issues).
* License: MIT
* Get citation information for `seaaroundus` in R doing `citation(package = 'seaaroundus')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
