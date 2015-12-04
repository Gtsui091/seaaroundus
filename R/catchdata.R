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
#' @param env API environment
#' Default: "prod"
#' @return data frame (or chart) with catch data for the requested region over time
#' @export
#' @examples
#' catchdata("eez", 76)
#' catchdata("eez", 76, measure="value", dimension="reporting-status")
#' \dontrun{
#' catchdata("eez", 76, chart=TRUE)
#' }
catchdata <- function(region, id, measure="tonnage", dimension="taxon", limit=10, chart=FALSE, env="prod") {

  # create url
  baseurl <- getapibaseurl(env)
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
