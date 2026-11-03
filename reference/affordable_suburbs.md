# Find suburbs within a budget

Averages each suburb's median weekly rent over the most recent quarters
in the data, for a chosen property type and number of bedrooms, and
keeps the suburbs whose average is at or below the budget.

## Usage

``` r
affordable_suburbs(
  data = vicrental::rentals,
  budget,
  property_type,
  bedrooms,
  quarters = 4,
  min_quarters = min(1, quarters),
  n = Inf
)
```

## Arguments

- data:

  A data frame with the same columns as
  [rentals](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/rentals.md).
  Defaults to
  [rentals](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/rentals.md).

- budget:

  Maximum weekly rent in dollars (number).

- property_type:

  Either "Flat" or "House".

- bedrooms:

  Number of bedrooms (integer).

- quarters:

  Number of most recent quarters to average over. Defaults to 4.

- min_quarters:

  Minimum number of those quarters a suburb must have data for. Defaults
  to 1, or to `quarters` if that is smaller.

- n:

  Maximum number of suburbs to return. Defaults to `Inf`, which returns
  all of them.

## Value

A tibble with columns `suburb`, `region`, `avg_rent` (average of the
quarterly median rents), `avg_lettings` (average over the period) and
`n_quarters` (quarters with data), ordered from cheapest to most
expensive. It has zero rows if no suburb is within budget.

## Examples

``` r
affordable_suburbs(budget = 450, property_type = "Flat", bedrooms = 2)
#> # A tibble: 46 × 5
#>    suburb               region                 avg_rent avg_lettings n_quarters
#>    <chr>                <chr>                     <dbl>        <dbl>      <int>
#>  1 Moe-Newborough       Other Regional Centres     301.         69            4
#>  2 Hamilton             Other Regional Centres     305          36.2          4
#>  3 Morwell              Other Regional Centres     308.         86            4
#>  4 Horsham              Other Regional Centres     310         101.           4
#>  5 Mildura              Other Regional Centres     344.        200.           4
#>  6 Sebastopol-Delacombe Ballarat                   345         114            4
#>  7 Wendouree-Alfredton  Ballarat                   347         104.           4
#>  8 Portland             Other Regional Centres     350          75.8          4
#>  9 Wanagaratta          Other Regional Centres     350         117            4
#> 10 Swan Hill            Other Regional Centres     351.         62.8          4
#> # ℹ 36 more rows
affordable_suburbs(budget = 350, property_type = "House", bedrooms = 3,
                   quarters = 3)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: suburb <chr>, region <chr>, avg_rent <dbl>,
#> #   avg_lettings <dbl>, n_quarters <int>
```
