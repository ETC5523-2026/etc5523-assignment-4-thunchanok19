# Rank top 10 suburbs by median rent by quarter

Return 10 suburbs with highest or lowest median weekly rent for a chosen
quarter, year, property type, and number of bedroom.

## Usage

``` r
top10_rent(
  data = vicrental::rentals,
  year,
  quarter,
  property_type,
  bedrooms,
  n = 10,
  highest = TRUE
)
```

## Arguments

- data:

  A data frame with the same columns as
  [rentals](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/rentals.md).
  Defaults to
  [rentals](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/rentals.md).

- year:

  Calendar year (integer).

- quarter:

  Quarter lebel, from Q1, Q2, Q3, or Q4.

- property_type:

  Either "Flat" or "House".

- bedrooms:

  Number of bedrooms (integer).

- n:

  Number of suburbs to return. Defaults to 10.

- highest:

  If 'TRUE' (default), return the most expensive suburbs. If 'FALSE',
  return the cheapest.

## Value

A tibble with columns `suburb`, `region`, `median_rent`, and
`new_lettings`, ordered by median rent. It has zero rows if no data
match the combination.

## Examples

``` r
top10_rent(year = 2022, quarter = "Q1", property_type = "Flat", bedrooms = 2)
#> # A tibble: 10 × 4
#>    suburb                 region             median_rent new_lettings
#>    <chr>                  <chr>                    <dbl>        <dbl>
#>  1 Fitzroy                Inner Melbourne            570          297
#>  2 Port Melbourne         Inner Melbourne            570          503
#>  3 Brighton               Southern Melbourne         545          398
#>  4 East Melbourne         Inner Melbourne            525          234
#>  5 Toorak                 Inner Melbourne            495          288
#>  6 Hampton-Beaumaris      Southern Melbourne         495          405
#>  7 Richmond-Burnley       Inner Melbourne            490         1105
#>  8 South Yarra            Inner Melbourne            485         1753
#>  9 Collingwood-Abbotsford Inner Melbourne            480          996
#> 10 Docklands              Inner Melbourne            470         1682
top10_rent(year = 2024, quarter = "Q2", property_type = "Flat", bedrooms = 1, n = 5,
highest = FALSE)
#> # A tibble: 5 × 4
#>   suburb              region                 median_rent new_lettings
#>   <chr>               <chr>                        <dbl>        <dbl>
#> 1 Swan Hill           Other Regional Centres         210           59
#> 2 Benalla             Other Regional Centres         230           29
#> 3 Moe-Newborough      Other Regional Centres         235           56
#> 4 Hamilton            Other Regional Centres         240           21
#> 5 Wendouree-Alfredton Ballarat                       250           62
```
