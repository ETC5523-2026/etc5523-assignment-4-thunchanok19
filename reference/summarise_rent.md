# Summarise median rent over time for one or more suburbs

Filters the rentals data to the chosen suburbs, property type and number
of bedrooms, and returns the median weekly rent and number of new
lettings for each suburb and quarter.

## Usage

``` r
summarise_rent(data = vicrental::rentals, suburb, property_type, bedrooms)
```

## Arguments

- data:

  A data frame with the same columns as
  [rentals](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/rentals.md).
  Defaults to
  [rentals](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/rentals.md).

- suburb:

  One or more suburb names (character vector) that appear in
  `data$suburb`.

- property_type:

  Either "Flat" or "House".

- bedrooms:

  Number of bedrooms (integer).

## Value

A tibble with columns `suburb`, `year`, `quarter`, `median_rent`,
`new_lettings` and `period` (a date for plotting), ordered by suburb and
time. It has zero rows if no data match the combination.

## Examples

``` r
summarise_rent(suburb = "Brunswick", property_type = "Flat", bedrooms = 2)
#> # A tibble: 103 × 6
#>    suburb     year quarter median_rent new_lettings period    
#>    <chr>     <int> <fct>         <dbl>        <dbl> <date>    
#>  1 Brunswick  2000 Q1              150          490 2000-03-01
#>  2 Brunswick  2000 Q2              150          542 2000-06-01
#>  3 Brunswick  2000 Q3              150          565 2000-09-01
#>  4 Brunswick  2000 Q4              150          549 2000-12-01
#>  5 Brunswick  2001 Q1              155          526 2001-03-01
#>  6 Brunswick  2001 Q2              160          491 2001-06-01
#>  7 Brunswick  2001 Q3              160          492 2001-09-01
#>  8 Brunswick  2001 Q4              165          535 2001-12-01
#>  9 Brunswick  2002 Q1              175          566 2002-03-01
#> 10 Brunswick  2002 Q2              175          573 2002-06-01
#> # ℹ 93 more rows
summarise_rent(suburb = c("Fitzroy", "Carlton North"),
               property_type = "Flat", bedrooms = 2)
#> # A tibble: 206 × 6
#>    suburb         year quarter median_rent new_lettings period    
#>    <chr>         <int> <fct>         <dbl>        <dbl> <date>    
#>  1 Carlton North  2000 Q1              215          117 2000-03-01
#>  2 Carlton North  2000 Q2              220          123 2000-06-01
#>  3 Carlton North  2000 Q3              220          130 2000-09-01
#>  4 Carlton North  2000 Q4              220          123 2000-12-01
#>  5 Carlton North  2001 Q1              230          136 2001-03-01
#>  6 Carlton North  2001 Q2              240          131 2001-06-01
#>  7 Carlton North  2001 Q3              250          129 2001-09-01
#>  8 Carlton North  2001 Q4              250          120 2001-12-01
#>  9 Carlton North  2002 Q1              250           99 2002-03-01
#> 10 Carlton North  2002 Q2              250          104 2002-06-01
#> # ℹ 196 more rows
```
