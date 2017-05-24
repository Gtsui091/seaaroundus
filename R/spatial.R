#' Get list of cells in a given shape
#' @param shape WKT representation of SRID 4326 polygon/multipolygon
#' @param ... curl options passed on to \code{\link[httr]{POST}}
#' @return list of cell ids
#' @export
#' @examples
#' getcells("POLYGON ((-48.177685950413291 15.842380165289299,
#' -48.177685950413291 15.842380165289299,
#' -54.964876033057919 28.964280991735578,
#' -35.960743801652967 27.606842975206646,
#' -48.177685950413291 15.842380165289299))")
getcells <- function(shape, ...) {
  return(
    postapi(paste(getapibaseurl(), "spatial/r/shape", sep = "/"),
            list(shape = shape), ...)
  )
}

#' Get a dataframe with catch data for a given list of cells and year
#' @param year year of data
#' Default: 2010
#' @param cells list of cell IDs
#' @param ... curl options passed on to \code{\link[httr]{POST}}
#' @return data frame with catch data for the requested cells and year
#' @export
#' @examples
#' getcelldata(2004, cells = 89568)
#' getcelldata(2008, cells = c(89568, 89569))
#' getcelldata(2011, cells = c(89568, 90288, 89569))
getcelldata <- function(year = 2010, cells, ...) {
  assert(year, c('numeric', 'integer'))
  assert(cells, c('numeric', 'integer'))
  body <- list(year = year)
  body <- c(body, as.list(stats::setNames(cells, rep("cells", length(cells)))))
  data <- postapi(url = paste(getapibaseurl(), "spatial/r/cells", sep = "/"),
                  body, ...)
  return(data.frame(data, stringsAsFactors = FALSE))
}
