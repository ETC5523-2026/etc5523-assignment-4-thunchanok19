#' Summarise median rent over time for one or more suburbs
#'
#' Filters the rentals data to the chosen suburbs, property type and number
#' of bedrooms, and returns the median weekly rent and number of new lettings
#' for each suburb and quarter.
#'
#' @param data A data frame with the same columns as [rentals].
#'   Defaults to [rentals].
#' @param suburb One or more suburb names (character vector) that appear
#'   in `data$suburb`.
#' @param property_type Either "Flat" or "House".
#' @param bedrooms Number of bedrooms (integer).
#'
#' @return A tibble with columns `suburb`, `year`, `quarter`, `median_rent`,
#'   `new_lettings` and `period` (a date for plotting), ordered by suburb
#'   and time. It has zero rows if no data match the combination.
#'
#' @examples
#' summarise_rent(suburb = "Brunswick", property_type = "Flat", bedrooms = 2)
#' summarise_rent(suburb = c("Fitzroy", "Carlton North"),
#'                property_type = "Flat", bedrooms = 2)
#'
#' @importFrom rlang .data
#' @export

summarise_rent <- function(data = vicrental::rentals,
                           suburb,
                           property_type,
                           bedrooms) {
  out <- data[data$suburb %in% suburb &
                data$property_type == property_type &
                data$no_of_bedroom == bedrooms, ]

  out |>
    dplyr::group_by(.data$suburb, .data$year, .data$quarter) |>
    dplyr::summarise(
      median_rent = stats::median(.data$median_rent, na.rm = TRUE),
      new_lettings = sum(.data$new_lettings, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      period = as.Date(paste0(.data$year, "-", as.integer(.data$quarter) * 3, "-01"))
    ) |>
    dplyr::arrange(.data$suburb, .data$period)
}


#' Rank top 10 suburbs by median rent by quarter
#'
#' Return 10 suburbs with highest or lowest median weekly rent for a chosen quarter, 
#' year, property type, and number of bedroom.
#'
#' @param data A data frame with the same columns as [rentals].
#'   Defaults to [rentals].
#' @param property_type Either "Flat" or "House".
#' @param bedrooms Number of bedrooms (integer).
#' @param quarter Quarter lebel, from Q1, Q2, Q3, or Q4.
#' @param year Calendar year (integer).
#' @param n Number of suburbs to return. Defaults to 10.
#' @param highest If 'TRUE' (default), return the most expensive suburbs. If 'FALSE',
#' return the cheapest.
#'
#' @return A tibble with columns `suburb`, `region`, `median_rent`, and
#'   `new_lettings`, ordered by median rent. 
#' It has zero rows if no data match the combination.
#'
#' @examples
#' top10_rent(year = 2022, quarter = "Q1", property_type = "Flat", bedrooms = 2)
#' top10_rent(year = 2024, quarter = "Q2", property_type = "Flat", bedrooms = 1, n = 5,
#' highest = FALSE)
#'
#' @export

top10_rent <- function(data = vicrental::rentals, 
  year, quarter, property_type, bedrooms, n = 10, highest = TRUE) {
  out <- data[data$year == year &
    data$quarter == quarter &
                data$property_type == property_type &
                data$no_of_bedroom == bedrooms, ]

out <- out[order(out$median_rent, decreasing = highest), ]
  out <- utils::head(out, n)

  dplyr::as_tibble(out[, c("suburb", "region", "median_rent", "new_lettings")])
}

#' Find suburbs within a budget
#'
#' Averages each suburb's median weekly rent over the most recent quarters
#' in the data, for a chosen property type and number of bedrooms, and keeps
#' the suburbs whose average is at or below the budget.
#'
#' @param data A data frame with the same columns as [rentals].
#'   Defaults to [rentals].
#' @param budget Maximum weekly rent in dollars (number).
#' @param property_type Either "Flat" or "House".
#' @param bedrooms Number of bedrooms (integer).
#' @param quarters Number of most recent quarters to average over.
#'   Defaults to 4.
#' @param min_quarters Minimum number of those quarters a suburb must have
#'   data for. Defaults to 1, or to `quarters` if that is smaller.
#' @param n Maximum number of suburbs to return.
#'   Defaults to `Inf`, which returns all of them.
#'
#' @return A tibble with columns `suburb`, `region`, `avg_rent` (average of
#'   the quarterly median rents), `avg_lettings` (average over the period) and
#'   `n_quarters` (quarters with data), ordered from cheapest to most
#'   expensive. It has zero rows if no suburb is within budget.
#'
#' @examples
#' affordable_suburbs(budget = 450, property_type = "Flat", bedrooms = 2)
#' affordable_suburbs(budget = 350, property_type = "House", bedrooms = 3,
#'                    quarters = 3)
#'
#' @importFrom rlang .data
#' @export
affordable_suburbs <- function(data = vicrental::rentals,
                               budget,
                               property_type,
                               bedrooms,
                               quarters = 4,
                               min_quarters = min(1, quarters),
                              n = Inf) {
  time_index <- data$year * 4L + as.integer(data$quarter)
  latest <- max(time_index)

  recent <- data[time_index > latest - quarters &
                   data$property_type == property_type &
                   data$no_of_bedroom == bedrooms, ]

  recent |>
    dplyr::group_by(.data$suburb, .data$region) |>
    dplyr::summarise(
      avg_rent = mean(.data$median_rent),
      avg_lettings = mean(.data$new_lettings),
      n_quarters = dplyr::n(),
      .groups = "drop"
    ) |>
    dplyr::filter(.data$n_quarters >= min_quarters,
                  .data$avg_rent <= budget) |>
    dplyr::arrange(.data$avg_rent)
}