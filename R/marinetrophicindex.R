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
#' \dontrun{
#' marinetrophicindex("eez", 76, chart=TRUE)
#' }
marinetrophicindex <- function(region, id, chart=FALSE, type="mean_trophic_level", transferefficiency=0.1) {

  # call API
  querystring <- paste("?region_id=", id, "&transfer_efficiency=", transferefficiency, sep="")
  # TODO rmti has 3 data sets
  data <- callapi(paste(getapibaseurl(), region, "marine-trophic-index", querystring, sep="/"))

  # get the data for the chart
  named_data <- data[[1]]
  names(named_data) <- data[[2]]
  data <- named_data[[type]]
  df <- data.frame(level=data[,2], row.names=data[,1])

  # return dataframe
  if (!chart) {
    return(df)

  # return chart
  } else {
    # TODO rmti has 3 data sets
    ylabel <- switch(type,
                     mean_trophic_level = "Trophic level of the catch",
                     fib_index = "Fishing-in-balance index",
                     rmti = "RMTI")
    title <- switch(type,
                    mean_trophic_level = "Marine Trophic Index",
                    fib_index = "Fishing in Balance Index",
                    rmti = "Region-based Marine Trophic Index")
    df <- data.frame(year=as.integer(unlist(rownames(df))), level=df[,1])
    graph <- ggplot(data=df, aes(x=year, y=level)) +
      scale_x_continuous(breaks=seq(min(df[["year"]]), max(df[["year"]]), 10), expand=c(0, 0)) +
      geom_line(colour="blue") + geom_point(colour="blue") +
      xlab("Year") + ylab(ylabel) + ggtitle(title)
    return(graph)
  }
}
