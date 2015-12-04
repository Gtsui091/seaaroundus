#' Get MTI as a data frame or chart
#' @param region region type
#' @param id region id
#' @param chart boolean to return a chart versus a data frame
#' Default: \code{FALSE}
#' @param type MTI data set ("mean_trophic_level", "fib_index", or "rmti")
#' Default: "mean_trophic_level"
#' @param transferefficiency float used for FiB index input
#' Default: 0.1
#' @param env API environment
#' Default: "prod"
#' @return data frame (or chart) with MTI data
#' @export
#' @examples
#' marinetrophicindex("eez", 76)
#' marinetrophicindex("eez", 76, type="fib_index")
#' marinetrophicindex("eez", 76, type="fib_index", transferefficiency=0.25)
#' \dontrun{
#' marinetrophicindex("eez", 76, chart=TRUE)
#' }
marinetrophicindex <- function(region, id, chart=FALSE, type="mean_trophic_level", transferefficiency=0.1, env="prod") {

  # call API
  querystring <- paste("?region_id=", id, "&transfer_efficiency=", transferefficiency, sep="")
  data <- callapi(paste(getapibaseurl(env), region, "marine-trophic-index", querystring, sep="/"))

  # get the data for the chart
  named_data <- data[[2]]
  names(named_data) <- data[[1]]

  # rmti has 3 data sets
  if (type == "rmti") {
    df <- data.frame(level_1950=named_data[["RMTI_1950"]][,2],
                     level_1962=named_data[["RMTI_1962"]][,2],
                     level_1972=named_data[["RMTI_1972"]][,2],
                     row.names=named_data[["RMTI_1950"]][,1])

  } else {
    data <- named_data[[type]]
    df <- data.frame(level=data[,2], row.names=data[,1])
  }

  # return dataframe
  if (!chart) {
    return(df)

  # return chart
  } else {
    ylabel <- switch(type,
                     mean_trophic_level = "Trophic level of the catch",
                     fib_index = "Fishing-in-balance index",
                     rmti = "RMTI")

    title <- switch(type,
                    mean_trophic_level = "Marine Trophic Index",
                    fib_index = "Fishing in Balance Index",
                    rmti = "Region-based Marine Trophic Index")

    years <- as.integer(unlist(rownames(df)))
    df[["year"]] <- years

    # rmti has 3 data sets
    if (type == "rmti") {
      graph <- ggplot(data=df, aes(x=year)) +
        geom_path(aes(y=level_1950, colour="blue")) +
        geom_path(aes(y=level_1962, colour="cyan"), na.rm=TRUE) +
        geom_path(aes(y=level_1972, colour="red"), na.rm=TRUE)

    } else {
      graph <- ggplot(data=df, aes(x=year, y=level)) +
        geom_path(colour="blue") + geom_point(colour="blue")
    }

    graph <- graph +
      scale_x_continuous(breaks=seq(min(years), max(years), 10), expand=c(0, 0)) +
      xlab("Year") + ylab(ylabel) + ggtitle(title) + theme(legend.position="none")

    return(graph)
  }
}
