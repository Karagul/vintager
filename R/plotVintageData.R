#' Plot vintage data
#'
#' This function plots results of \code{GetVintageData} function. All \code{Slicers} in results have
#' to be included in plot definition.
#'
#' @param data Result of \code{GetVintageData} function.
#' @param x Data to be displayed on \code{x} axis. Default is \code{distance}.
#' @param y Data to be displayed on \code{y} axis. Default is \code{event_weight_csum_pct}.
#' @param cond Variable to be used for conditioning (in-chart group).
#' @param facets Formulat to be used for facetting.
#' @examples
#' plotVintageData(vintageData, facets='product~region')
#' plotVintageData(vintageData, cond = 'origination_month', facets='product~region')
#' plotVintageData(vintageData, cond = 'origination_month', facets='region~product')
#' plotVintageData(vintageData, x = 'origination_month', cond = 'distance', 
#'                 facets='region~product')
#' @export 


plotVintageData <- function(data = NULL, x = "distance", y = "event_weight_csum_pct",
                            cond = NULL , facets = NULL) {
  
  `%ni%` <- Negate(`%in%`)
  
  dataNames <- toupper(names(data))
  x <- toupper(x)
  y <- toupper(y)

  displayVars <- dataNames[!(dataNames %in% c("distance","vintage_unit_weight","vintage_unit_count","event_weight",
                                                                "event_weight_pct","event_weight_csum","event_weight_csum_pct",
                                                                "rn"))]  
  for (col in dataNames) {
    if (class(data[[col]])[1] %in% c("Date",'POSIXct','POSIXt')) {
      data[[col]] <- as.factor(data[[col]])
    }
  }
  
  BasicPlot <- ggplot(data, aes_string(x=x, y=y))
  
  if (x %ni% dataNames) stop (paste("Variable",x,"is not in data frame."))
  if (y %ni% dataNames) stop (paste("Variable",y,"is not in data frame."))
  if (length(cond)>1) stop (paste("Only one variable can be specified for conditioning."))
  if (length(cond)==1) {
    if (cond %ni% dataNames) stop (paste("Conditioning variable",cond,"is not in data frame."))
  }
  if(!is.null(facets) ) {
    # add sanity check
  }

  if (!is.null(cond)) {
    BasicPlot <- BasicPlot + geom_line(aes_string(group=cond, colour=cond))
  } else {
    BasicPlot <- BasicPlot + geom_line()
  }
    
  
  if(!is.null(facets)) {
    if (substr(facets,1,1) == "~" & !grepl("+",facets,fixed=TRUE)) {
      BasicPlot <- BasicPlot + facet_wrap(as.formula(facets))            
    } else {
      BasicPlot <- BasicPlot + facet_grid(as.formula(facets))      
    }
  }
  
  BasicPlot + 
    ylab("Vintage measure") +
    ggtitle("Vintage Analysis") 
    #scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0))
}
