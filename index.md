# vicrental

## Purpose

`vicrental` helps renters in Victoria explore rental prices by suburb.
It includes a cleaned dataset, functions to summarise and rank rents,
and a Shiny app that answers: *how have rents changed, which suburbs are
the most or least expensive, and where can I afford to live?*

## Data

The `rentals` dataset contains median weekly rents and the number of new
lettings for flats and houses across Victorian suburbs, by quarter and
number of bedrooms.

- **Source:** Victorian Department of Families, Fairness and Housing
  (DFFH) [Rental
  Report](https://www.dffh.vic.gov.au/publications/rental-report),
  compiled at <https://publicdata.au/d/vic-rents-by-suburb/>.
- **Preparation:** `data-raw/rentals.R` reads the raw CSV, removes
  aggregate rows (“All properties”, “Group Total”) and rows with missing
  values, splits the property description into number of bedrooms and
  property type, and derives year and quarter.
- **Columns:** see
  [`?rentals`](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/rentals.md).

## Installation

You can install the development version of vicrental from
[GitHub](https://github.com/ETC5523-2026/etc5523-assignment-4-thunchanok19)
with:

``` r

# install.packages("pak")
pak::pak("ETC5523-2026/etc5523-assignment-4-thunchanok19")
```

## Launch the app

``` r

library(vicrental)
run_app()
```

The app opens on an About tab and has four tabs in total:

- **About:** explains who the app is for, the question it answers, how
  to use the controls and what the fields mean. Each other tab has a
  “How to read this” note under its output.
- **Compare suburbs:** compare median rents across up to three suburbs
  over time.
- **Top 10 rankings:** rank the highest or lowest rent suburbs in a
  selected quarter and year.
- **Affordability:** find suburbs within a weekly rent budget for a
  selected property type and number of bedrooms.

## Functions

- [`summarise_rent()`](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/summarise_rent.md):
  median rent over time for chosen suburbs.
- [`top10_rent()`](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/top10_rent.md):
  the highest or lowest rent suburbs in a selected quarter and year.
- [`affordable_suburbs()`](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/affordable_suburbs.md):
  suburbs within a weekly rent budget.
- [`run_app()`](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/run_app.md):
  launches the Shiny app.
