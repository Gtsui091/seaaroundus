#' Get a map of the region specified
#' @param region region type
#' @param id region id
#' @param env API environment
#' Default: "prod"
#' @return map of the region
#' @export
#' @examples
#' \dontrun{
#' regionmap("eez")
#' regionmap("eez", 76)
#' }
regionmap <- function(region, id, env="prod") {

  # draw all regions
  url <- paste(getapibaseurl(env), region, "?geojson=true", sep="/")
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
