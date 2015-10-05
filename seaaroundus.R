library(httr)
library(jsonlite)
library(ggplot2)
library(grid)
library(scales)

# get catch data for a region as a dataframe or stacked area chart
getcatchdata <- function(region, id, measure="tonnage", dimension="taxon", limit=10, chart=F) {

  # create url
  baseurl <- "http://api.qa1.seaaroundus.org/api/v1"
  querystring <- paste("?region_id=", id, "&limit=", limit, sep="")
  url <- paste(baseurl, region, measure, dimension, querystring, sep="/")

  # call API
  resp <- GET(url)
  stop_for_status(resp)

  # extract data from response
  data <- fromJSON(content(resp, "text"))$data
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

    plot <- ggplot(df, aes(year, data)) +
      geom_area(aes(fill=dim), position="stack") +
      theme(legend.position="top", legend.key.size=unit(8, "native")) +
      scale_x_continuous(breaks=seq(min(years), max(years), 10), expand=c(0, 0)) +
      scale_y_continuous(breaks=pretty_breaks(n=10), expand=c(0, 0)) +
      guides(fill=guide_legend(title=NULL, direction="horizontal", byrow=T, ncol=5)) +
      ylab(ylabel) + xlab("Year") + ggtitle(charttitle)

    return(plot)
  }
}
