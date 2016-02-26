#' Get data for percent of High Seas vs. EEZ catches as a data frame or chart
#' @param chart boolean to return a chart versus a data frame
#' Default: \code{FALSE}
#' @return data frame (or chart) with High Seas vs. EEZ data for the requested region over time
#' @export
#' @examples
#' eezsvshighseas()
#' \dontrun{
#' eezsvshighseas(chart=TRUE)
#' }

eezsvshighseas <- function(chart=FALSE) {

  # call API
  data <- callapi(paste(getapibaseurl(), "global", "eez-vs-high-seas", "", sep="/"))

  # create dataframe
  values <- data$values
  years <- as.numeric(values[[1]][,1])
  df <- data.frame(as.double(values[[1]][,2]), as.double(values[[2]][,2]), row.names=years)
  colnames(df) <- c("EEZ percent catch", "High Seas percent catch")

  # return dataframe
  if (!chart) {
    return(df)

  # return chart
  } else {
    df <- Reduce(function(...) rbind(...), lapply(colnames(df), function(name) {
      data.frame(year=years, data=df[,name], dim=rep(name, nrow(df)))
    }))

    plot <- ggplot(df, aes(year, data)) +
      geom_area(aes(fill=dim), position="stack") +
      theme(legend.position="top", legend.key.size=unit(8, "native")) +
      scale_x_continuous(breaks=seq(min(years), max(years), 10), expand=c(0, 0)) +
      scale_y_continuous(breaks=seq(0, 100, 20), limits=c(0, 100), expand=c(0, 0)) +
      guides(fill=guide_legend(title=NULL, direction="horizontal", byrow=TRUE, ncol=5)) +
      scale_fill_manual(values=c("#ADC6E9", "#1776B6")) +
      ylab("Percent of global catch") + xlab("Year") + ggtitle("Percent of landings in EEZs vs. High Seas")

    return(plot)
  }
}
