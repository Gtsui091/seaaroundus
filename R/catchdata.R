#' Get catch data for a region as a dataframe
#'
#' @export
#' @param region (character) region of the data. Only one of "eez", "lme", "rfmo", "meow" will return data.
#' @param id (integer/numeric) region id. depends on what
#' \code{region} is specified. See \code{\link{listregions}} for details .
#' @param ... curl options passed on to [crul::HttpClient()].
#' @return data frame with catch data for the requested
#' region over the period 1950-2014.
#' @examples
#' catchdata("eez", 76)
#' head(catchdata("eez", 76))
#' catchdata("rfmo", 1)
#' 
catchdata <- function(region, id, ...) {
  if (!region %in% c("eez", "lme", "rfmo", "meow")) stop('check region is one of "eez", "lme", "rfmo", "meow"') 
  # create url path and query parameters
  path <- paste("api/v1/R", region,id, sep='/')
  args <- list()
  # call API
  df <- callapi(path,args)
  if (is.null(df)) return(data.frame(NULL))
  return(df)
}
