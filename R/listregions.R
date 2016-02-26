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
