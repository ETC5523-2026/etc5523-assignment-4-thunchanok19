#' Launch the Victorian rents Shiny app
#'
#' Opens an interactive app for exploring median rent over time
#' for a chosen suburb, property type and number of bedrooms.
#'
#' @return No return value. Called for its side effect of starting the app.
#'
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
#'
#' @export
run_app <- function() {
  app_dir <- system.file("app", package = "vicrental")
  if (app_dir == "") {
    stop("Could not find the app directory. Try reinstalling `vicrental`.",
         call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}