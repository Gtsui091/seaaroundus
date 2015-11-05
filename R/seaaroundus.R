#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import ggplot2
#' @import grid
#' @import scales
#' @import rgdal
#' @import maps
#' @import sp

# get the base URL of the API
getapibaseurl <- function() {
  return("http://api.qa1.seaaroundus.org/api/v1")
}

# call API and return data
callapi <- function(url) {
  resp <- GET(url)
  stop_for_status(resp)
  data <- fromJSON(content(resp, "text"))$data
  return(data)
}

#' Get catch data for a region as a dataframe or stacked area chart
#' @param region region type
#' @param id region id
#' @param measure measure of the data
#' Default: "tonnage"
#' @param dimension dimension data is bucketed on
#' Default: "taxon"
#' @param limit number of buckets of data plus one for "others"
#' Default: 10
#' @param chart boolean to return a chart versus a data frame
#' Default: \code{FALSE}
#' @return data frame (or chart) with catch data for the requested region over time
#' @export
#' @examples
#' getcatchdata("eez", 76)
#' getcatchdata("eez", 76, measure="value", dimension="reporting-status")
#' getcatchdata("eez", 76, chart=TRUE)
getcatchdata <- function(region, id, measure="tonnage", dimension="taxon", limit=10, chart=FALSE) {

  # create url
  baseurl <- getapibaseurl()
  querystring <- paste("?region_id=", id, "&limit=", limit, sep="")
  url <- paste(baseurl, region, measure, dimension, querystring, sep="/")

  # call API
  data <- callapi(url)

  # extract data from response
  values <- data$values
  years <- values[[1]][,1]
  cols <- lapply(values, function(v) { v[,2] })

  # create dataframe
  df <- data.frame(cols, row.names=years)
  df[is.na(df)] <- 0
  colnames(df) <- data$key

  # return dataframe
  if (!chart) {
    return(df)

  # return chart
  } else {
    ylabel <- ifelse(measure == "tonnage", "Catch (t x 1000)", "Real 2005 value (million US$)")
    charttitle <- toupper(paste(region, id, measure, "by", dimension, sep=" "))

    df <- Reduce(function(...) rbind(...), lapply(colnames(df), function(name) {
      coldata <- df[,name] / ifelse(measure=="tonnage", 10^3, 10^6)
      data.frame(year=years, data=coldata, dim=rep(name, nrow(df)))
    }))

    spectral <- c("#9e0142", "#d53e4f", "#f46d43", "#fdae61", "#fee08b", "#ffffbf", "#e6f598", "#abdda4", "#66c2a5",
      "#3288bd", "#5e4fa2", '#666', '#f88', '#88f', '#8f8', '#800', '#080', '#008', '#888', '#333')
    chartcolors <- rep(spectral, 10)

    plot <- ggplot(df, aes(year, data)) +
      geom_area(aes(fill=dim), position="stack") +
      theme(legend.position="top", legend.key.size=unit(8, "native")) +
      scale_x_continuous(breaks=seq(min(years), max(years), 10), expand=c(0, 0)) +
      scale_y_continuous(breaks=pretty_breaks(n=10), expand=c(0, 0)) +
      guides(fill=guide_legend(title=NULL, direction="horizontal", byrow=TRUE, ncol=5)) +
      scale_fill_manual(values=chartcolors) +
      ylab(ylabel) + xlab("Year") + ggtitle(charttitle)

    return(plot)
  }
}

#' Get a map of the region specified
#' @param region region type
#' @param id region id
#' @return map of the region
#' @export
#' @examples
#' getregionmap("eez")
#' getregionmap("eez", 76)
getregionmap <- function(region, id) {

  # draw all regions
  url <- paste(getapibaseurl(), region, "?geojson=true", sep="/")
  regions <- fortify(readOGR(dsn=url, layer=ogrListLayers(url), verbose=FALSE))

  if (!missing(id)) { # draw specified region
    url <- paste(getapibaseurl(), region, paste(id, "?geojson=true", sep=""), sep="/")
    rsp <- readOGR(dsn=url, layer=ogrListLayers(url), verbose=FALSE)
    regionmap <- fortify(rsp)

    # get bounds for map zoom
    bounds <- bbox(rsp)
    dim <- round(max(diff(bounds[1,]), diff(bounds[1,])))
    center <- c(mean(bounds[1,]), mean(bounds[2,]))
    xlim <- c(center[1] - dim, center[1] + dim)
    ylim <- c(center[2] - dim, center[2] + dim)
  }

  # draw the map
  map <- ggplot() +
    geom_map(data=regions, map=regions, aes(map_id=id, x=long, y=lat), colour="#394D66", fill="#536D8E", size=0.25)

  if (!missing(id)) {
    map <- map +
      geom_map(data=regionmap, map=regionmap, aes(map_id=id, x=long, y=lat), colour="#449FD5", fill="#CAD9EC", size=0.25)
  }

  if (identical(region, "eez") && !missing(id)) { # use ifa for eez
    url <- paste(getapibaseurl(), region, id, "ifa", "?geojson=true", sep="/")
    ifa <- fortify(readOGR(dsn=url, layer=ogrListLayers(url), verbose=FALSE))
    map <- map + geom_map(data=ifa, map=ifa, aes(map_id=id, x=long, y=lat), colour="#E96063", fill="#E38F95", size=0.25)
  }

  map <- map + borders("world", colour="#333333", fill="#EDE49A", size=0.25) + theme_map()

  if (!missing(id)) {
    map <- map + coord_equal(xlim=xlim, ylim=ylim)
  } else {
    map <- map + coord_equal()
  }

  return(map)
}

#' List available regions for a region type
#' @param region region type
#' @return a data frame with region ids and title(s)
#' @export
#' @examples
#' listregions("eez")
listregions <- function(region) {

  # create url
  baseurl <- getapibaseurl()
  url <- paste(baseurl, region, "?nospatial=true", sep="/")

  # call API
  data <- callapi(url)

  # extract data from response
  df <- data.frame(data, row.names='id')
  return(df)
}

# make maps look nicer
# from: https://gist.github.com/hrbrmstr/33baa3a79c5cfef0f6df
theme_map <- function(base_size=9, base_family="") {
  theme_bw(base_size=base_size, base_family=base_family) %+replace%
  theme(axis.line=element_blank(),
    axis.text=element_blank(),
    axis.ticks=element_blank(),
    axis.title=element_blank(),
    panel.background=element_rect(fill='#81A6D6', colour='#333333'),
    panel.border=element_blank(),
    panel.grid=element_blank(),
    panel.margin=unit(0, "lines"),
    plot.background=element_blank(),
    legend.justification=c(0,0),
    legend.position=c(0,0)
  )
}
