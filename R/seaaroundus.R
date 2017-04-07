#' @name rseaaroundus
#' @docType package
#' @title R library for Sea Around Us
#' @description: Access Sea Around Us catch data and view it as data frames or stacked area charts.
#' @author Robert Scott Reis \email{reis.robert.s@@gmail.com}
#' @keywords package

#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import ggplot2
#' @import grid
#' @import scales
#' @import rgdal
#' @import maps
#' @import sp

globalVariables(c("year", "level_1950", "level_1962", "level_1968", "level", "long", "lat"))
