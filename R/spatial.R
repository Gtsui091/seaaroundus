#' Get list of cells in a given shape
#' @param shape WKT representation of SRID 4326 polygon/multipolygon
#' @return list of cell ids
#' @export
#' @examples
#' getcells("POLYGON ((-48.177685950413291 15.842380165289299,-48.177685950413291 15.842380165289299,
#' -54.964876033057919 28.964280991735578,-35.960743801652967 27.606842975206646,-48.177685950413291 
#' 15.842380165289299))")
getcells <- function(shape) {
  return(postapi(url <- paste(getapibaseurl(), "spatial/r/shape", sep="/"), list(shape = shape)))
}
