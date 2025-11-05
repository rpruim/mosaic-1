#' Create a vgplot visualization
#'
#' @param data A data.frame or list to visualize
#' @param marks A list of marks (plot elements) to add to the visualization
#' @param options A list of plot options (width, height, etc.)
#' @param width Plot width in pixels
#' @param height Plot height in pixels
#' @param elementId Optional element ID
#'
#' @export
vgplot <- function(data = NULL, marks = list(), options = list(), 
                   width = NULL, height = NULL, elementId = NULL) {
  
  # Convert data.frame to list format if needed
  if (is.data.frame(data)) {
    data <- df_to_vgplot_data(data)
  }
  
  # Create the widget data
  x <- list(
    data = data,
    marks = marks,
    options = options
  )
  
  # Create the widget
  htmlwidgets::createWidget(
    name = 'vgplot',
    x = x,
    width = width,
    height = height,
    package = 'vgplotr',
    elementId = elementId
  )
}

#' Add a mark to a vgplot
#'
#' @param plot A vgplot object
#' @param mark A mark specification
#' @export
add_mark <- function(plot, mark) {
  plot$x$marks <- append(plot$x$marks, list(mark))
  plot
}

#' Create a dot mark
#'
#' @param data Data source name or specification
#' @param x X-axis encoding
#' @param y Y-axis encoding
#' @param ... Additional mark properties
#' @export
vg_dot <- function(data = NULL, x = NULL, y = NULL, ...) {
  mark <- list(
    mark = "dot",
    data = data,
    x = x,
    y = y
  )
  
  # Add additional properties
  extra_props <- list(...)
  if (length(extra_props) > 0) {
    mark <- c(mark, extra_props)
  }
  
  mark
}

#' Create a line mark
#'
#' @param data Data source name or specification
#' @param x X-axis encoding
#' @param y Y-axis encoding
#' @param ... Additional mark properties
#' @export
vg_line <- function(data = NULL, x = NULL, y = NULL, ...) {
  mark <- list(
    mark = "line",
    data = data,
    x = x,
    y = y
  )
  
  # Add additional properties
  extra_props <- list(...)
  if (length(extra_props) > 0) {
    mark <- c(mark, extra_props)
  }
  
  mark
}

#' Create a bar mark
#'
#' @param data Data source name or specification
#' @param x X-axis encoding
#' @param y Y-axis encoding
#' @param ... Additional mark properties
#' @export
vg_bar <- function(data = NULL, x = NULL, y = NULL, ...) {
  mark <- list(
    mark = "barY",
    data = data,
    x = x,
    y = y
  )
  
  # Add additional properties
  extra_props <- list(...)
  if (length(extra_props) > 0) {
    mark <- c(mark, extra_props)
  }
  
  mark
}

#' Create an area mark
#'
#' @param data Data source name or specification
#' @param x X-axis encoding
#' @param y Y-axis encoding
#' @param ... Additional mark properties
#' @export
vg_area <- function(data = NULL, x = NULL, y = NULL, ...) {
  mark <- list(
    mark = "areaY",
    data = data,
    x = x,
    y = y
  )
  
  # Add additional properties
  extra_props <- list(...)
  if (length(extra_props) > 0) {
    mark <- c(mark, extra_props)
  }
  
  mark
}

#' Set plot dimensions
#'
#' @param width Width in pixels
#' @param height Height in pixels
#' @export
vg_width <- function(width) {
  list(width = width)
}

#' @rdname vg_width
#' @export
vg_height <- function(height) {
  list(height = height)
}

#' Shiny bindings for vgplot
#'
#' @param outputId output variable to read from
#' @param width Must be a valid CSS unit
#' @param height Must be a valid CSS unit
#' @export
vgplotOutput <- function(outputId, width = '100%', height = '400px') {
  htmlwidgets::shinyWidgetOutput(outputId, 'vgplot', width, height, package = 'vgplotr')
}

#' @rdname vgplotOutput
#' @export
renderVgplot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) }
  htmlwidgets::shinyRenderWidget(expr, vgplotOutput, env, quoted = TRUE)
}