#' Get MTI as a data frame or chart
#' @param region region type
#' @param id region id
#' @param chart boolean to return a chart versus a data frame
#' Default: \code{FALSE}
#' @param type MTI data set ("mean_trophic_level", "fib_index", or "rmti")
#' Default: "mean_trophic_level"
#' @param transferefficiency float used for FiB index input
#' Default: 0.1
#' @return data frame (or chart) with MTI data
#' @export
#' @examples
#' marinetrophicindex("eez", 76)
#' marinetrophicindex("eez", 76, type="fib_index")
#' marinetrophicindex("eez", 76, type="fib_index", transferefficiency=0.25)
marinetrophicindex <- function(region, id, chart=FALSE, type="mean_trophic_level", transferefficiency=0.1) {

  # call API
  querystring <- paste("?region_id=", id, "&transfer_efficiency=", transferefficiency, sep="")
  data <- callapi(paste(getapibaseurl(), region, "marine-trophic-index", querystring, sep="/"))

  # get the data for the chart
  named_data <- data[[1]]
  names(named_data) <- data[[2]]
  data <- named_data[[type]]
  df <- data.frame(mtl=data[,2], row.names=data[,1])

  # return dataframe
  if (!chart) {
    return(df)

  # return chart
  } else {
    #TODO
  }
}
