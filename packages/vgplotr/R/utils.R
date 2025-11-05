#' Convert data.frame to vgplot data format
#'
#' @param df A data.frame
#' @return A list suitable for vgplot
df_to_vgplot_data <- function(df) {
  # Convert each column to appropriate JavaScript type
  result <- list()
  
  for (col_name in names(df)) {
    col <- df[[col_name]]
    
    if (is.factor(col)) {
      result[[col_name]] <- as.character(col)
    } else if (is.character(col)) {
      result[[col_name]] <- col
    } else if (is.numeric(col)) {
      result[[col_name]] <- col
    } else if (inherits(col, "Date")) {
      result[[col_name]] <- as.character(col)
    } else if (inherits(col, "POSIXt")) {
      result[[col_name]] <- as.character(col)
    } else {
      result[[col_name]] <- as.character(col)
    }
  }
  
  # Convert to row-based format
  nrows <- nrow(df)
  rows <- vector("list", nrows)
  
  for (i in 1:nrows) {
    row <- list()
    for (col_name in names(result)) {
      row[[col_name]] <- result[[col_name]][i]
    }
    rows[[i]] <- row
  }
  
  rows
}

#' Create a data specification from a data.frame
#'
#' @param data A data.frame
#' @param name Optional name for the dataset
#' @export
vg_data <- function(data, name = "data") {
  if (is.data.frame(data)) {
    list(
      name = name,
      values = df_to_vgplot_data(data)
    )
  } else {
    data
  }
}

#' Create a from() specification
#'
#' @param name Name of the data source
#' @export
vg_from <- function(name) {
  list(from = name)
}