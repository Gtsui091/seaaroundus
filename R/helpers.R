# get the base URL of the API
getapibaseurl <- function() {
  return("http://api.seaaroundus.org/api/v1")
}

# call API with GET and return data
callapi <- function(url) {
  resp <- GET(url, add_headers("X-Request-Source" = "r"))
  stop_for_status(resp)
  data <- fromJSON(content(resp, "text"))$data
  return(data)
}

# call API with POST and return data
postapi <- function(url, body) {
  resp <- POST(url, body=body, add_headers("X-Request-Source" = "r"))
  stop_for_status(resp)
  data <- fromJSON(content(resp, "text"))$data
  return(data)
}

# make maps look nicer
# from: https://gist.github.com/hrbrmstr/33baa3a79c5cfef0f6df
theme_map <- function(base_size=9, base_family="") {
  theme_bw(base_size=base_size, base_family=base_family) %+replace%
  theme(axis.line=element_blank(),
    axis.text=element_blank(),
    axis.ticks=element_blank(),
    axis.title=element_blank(),
    panel.background=element_rect(fill='#81A6D6', colour='#333333'),
    panel.border=element_blank(),
    panel.grid=element_blank(),
    panel.margin=unit(0, "lines"),
    plot.background=element_blank(),
    legend.justification=c(0,0),
    legend.position=c(0,0)
  )
}
