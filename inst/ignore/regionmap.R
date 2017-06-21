#' Get a map of the region specified
#'
#' @export
#' @template regionid
#' @return map of the region
#' @note there's a number of warnings that print, all related to \pkg{ggplot2},
#' they are most likely okay, and don't indicate a problem
#' @examples \dontrun{
#' regionmap("eez")
#' regionmap(region = "eez", id = 76)
#'
#' # a different region type
#' regionmap(region = "lme", id = 23)
#' }
regionmap <- function(region, id) {
  url <- paste(getapibaseurl(), region, "?geojson=true", sep = "/")
  tfile <- tempfile()
  on.exit(unlink(tfile))
  res <- httr::GET(url, httr::write_disk(tfile))
  dat <- sf::read_sf(tfile)
  ggplot2::fortify(dat)
  ggplot(dat) +
    geom_sf()

  # draw all regions
  url <- paste(getapibaseurl(), region, "?geojson=true", sep = "/")
  tfile <- tempfile()
  on.exit(unlink(tfile))
  res <- httr::GET(url, httr::write_disk(tfile))
  regions <- ggplot2::fortify(
    rgdal::readOGR(dsn = tfile, layer = rgdal::ogrListLayers(tfile),
                   verbose = FALSE))

  if (!missing(id)) { # draw specified region
    url <- paste(getapibaseurl(), region, paste(id, "?geojson=true", sep = ""),
                 sep = "/")
    tfile2 <- tempfile()
    on.exit(unlink(tfile2))
    res <- httr::GET(url, httr::write_disk(tfile2))
    rsp <- rgdal::readOGR(dsn = tfile2, layer = rgdal::ogrListLayers(tfile2),
                          verbose = FALSE)
    regionmap <- ggplot2::fortify(rsp)

    # get bounds for map zoom
    bounds <- sp::bbox(rsp)
    dim <- round(max(diff(bounds[1,]), diff(bounds[1,])))
    center <- c(mean(bounds[1,]), mean(bounds[2,]))
    xlim <- c(center[1] - dim, center[1] + dim)
    ylim <- c(center[2] - dim, center[2] + dim)
  }

  # draw the map
  map <- ggplot() +
    geom_map(data = regions, map = regions,
             aes(map_id = id, x = long, y = lat),
             colour = "#394D66", fill = "#536D8E", size = 0.25)

  if (!missing(id)) {
    map <- map +
      geom_map(data = regionmap, map = regionmap,
               aes(map_id = id, x = long, y = lat),
               colour = "#449FD5", fill = "#CAD9EC", size = 0.25)
  }

  if (identical(region, "eez") && !missing(id)) { # use ifa for eez
    url <- paste(getapibaseurl(), region, id, "ifa", "?geojson=true", sep = "/")
    tfile3 <- tempfile()
    on.exit(unlink(tfile3))
    res <- httr::GET(url, httr::write_disk(tfile3))
    ifa <- ggplot2::fortify(
      rgdal::readOGR(dsn = tfile3,
                     layer = rgdal::ogrListLayers(tfile3), verbose = FALSE))
    map <- map +
      geom_map(data = ifa, map = ifa, aes(map_id = id, x = long, y = lat),
               colour = "#E96063", fill = "#E38F95", size = 0.25)
  }

  map <- map +
    borders("world", colour = "#333333", fill = "#EDE49A", size = 0.25) +
    theme_map()

  if (!missing(id)) {
    map <- map + coord_equal(xlim = xlim, ylim = ylim)
  } else {
    map <- map + coord_equal()
  }

  return(map)
}
