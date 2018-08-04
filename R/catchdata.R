#' Get catch data for a region as a dataframe
#'
#' @export
#' @template regionid
#' @examples
#' catchdata("eez", 76)
#' \dontrun{
#' catchdata(region = "eez", id = 76)
#' }
#' 
catchdata <- function(region, id, ...) {

    data <- fromJSON(paste(getapibaseurl(),'api/v1/R',region,id, sep='/'))
    
    df <- data$data
    print('Metadata:')
    print(data$meta)
    return(df)
  
}
