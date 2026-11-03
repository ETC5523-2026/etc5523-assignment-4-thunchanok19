# Getting started with vicrental

``` r

library(vicrental)
```

`vicrental` helps people renting, or planning to rent, in Victoria
explore rents by suburb. This vignette shows how to install the package,
launch the app, use each tab and interpret what you see.

## Install

Install the package from GitHub:

``` r

# install.packages("pak")
pak::pak("ETC5523-2026/etc5523-assignment-4-thunchanok19")
```

## Launch the app

``` r

library(vicrental)
run_app()
```

The app opens on an **About** tab that explains who it is for, the
question it answers and what each field means. The other tabs are
described below.

## Using the app

**Compare suburbs.** Choose up to three suburbs, a property type and a
number of bedrooms. The plot shows the median weekly rent of new
lettings by quarter, with one line per suburb. Hover over a line to see
the quarter, median rent and number of new lettings.

**Top 10 rankings.** Choose a year, quarter, property type and number of
bedrooms, then choose whether to rank from the most or least expensive
suburbs. Use the slider to show between 3 and 10 suburbs. Bars are
coloured by region.

**Affordability.** Set a weekly rent budget, a property type, a number
of bedrooms and how many recent quarters to average over. The table
lists suburbs whose average rent is at or below your budget. Click a
column header to sort, or use the search box to find a suburb.

If a combination has no data, for example a house with one bedroom, the
app shows a message instead of an empty chart.

## Using the functions directly

The functions behind the app can be used in your own R code. The
`rentals` dataset is included in the package:

``` r

head(rentals)
#>   year quarter property_type no_of_bedroom new_lettings median_rent
#> 1 2000      Q1          Flat             1          352         165
#> 2 2000      Q2          Flat             1          347         165
#> 3 2000      Q3          Flat             1          378         170
#> 4 2000      Q4          Flat             1          369         175
#> 5 2001      Q1          Flat             1          395         180
#> 6 2001      Q2          Flat             1          411         185
#>            region                                suburb
#> 1 Inner Melbourne Albert Park-Middle Park-West St Kilda
#> 2 Inner Melbourne Albert Park-Middle Park-West St Kilda
#> 3 Inner Melbourne Albert Park-Middle Park-West St Kilda
#> 4 Inner Melbourne Albert Park-Middle Park-West St Kilda
#> 5 Inner Melbourne Albert Park-Middle Park-West St Kilda
#> 6 Inner Melbourne Albert Park-Middle Park-West St Kilda
```

### Rent over time

[`summarise_rent()`](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/summarise_rent.md)
returns the median rent for each quarter for one or more suburbs for the
selected property type and number of bedrooms:

``` r

fitzroy <- summarise_rent(
  suburb = "Fitzroy",
  property_type = "Flat",
  bedrooms = 2
)
head(fitzroy)
#> # A tibble: 6 × 6
#>   suburb   year quarter median_rent new_lettings period    
#>   <chr>   <int> <fct>         <dbl>        <dbl> <date>    
#> 1 Fitzroy  2000 Q1              283           94 2000-03-01
#> 2 Fitzroy  2000 Q2              290          109 2000-06-01
#> 3 Fitzroy  2000 Q3              290          115 2000-09-01
#> 4 Fitzroy  2000 Q4              290          128 2000-12-01
#> 5 Fitzroy  2001 Q1              300          148 2001-03-01
#> 6 Fitzroy  2001 Q2              300          147 2001-06-01
```

### Highest and lowest rent suburbs

[`top10_rent()`](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/top10_rent.md)
ranks suburbs in one quarter for the selected property type and number
of bedrooms. Use `n` to choose how many suburbs to show, and `highest`
to rank from the highest or lowest rent:

``` r

top10_rent(
  year = 2024,
  quarter = "Q2",
  property_type = "Flat",
  bedrooms = 2,
  n = 5,
  highest = TRUE
)
#> # A tibble: 5 × 4
#>   suburb          region          median_rent new_lettings
#>   <chr>           <chr>                 <dbl>        <dbl>
#> 1 Docklands       Inner Melbourne         710         1293
#> 2 Fitzroy         Inner Melbourne         710          226
#> 3 CBD-St Kilda Rd Inner Melbourne         700         6734
#> 4 Port Melbourne  Inner Melbourne         700          376
#> 5 Southbank       Inner Melbourne         700         2373
```

### Suburbs within a budget

[`affordable_suburbs()`](https://etc5523-2026.github.io/etc5523-assignment-4-thunchanok19/reference/affordable_suburbs.md)
averages rent over the most recent quarters and keeps suburbs at or
below a weekly budget:

``` r

head(
  affordable_suburbs(
    budget = 450,
    property_type = "Flat",
    bedrooms = 2,
    quarters = 4
  )
)
#> # A tibble: 6 × 5
#>   suburb               region                 avg_rent avg_lettings n_quarters
#>   <chr>                <chr>                     <dbl>        <dbl>      <int>
#> 1 Moe-Newborough       Other Regional Centres     301.         69            4
#> 2 Hamilton             Other Regional Centres     305          36.2          4
#> 3 Morwell              Other Regional Centres     308.         86            4
#> 4 Horsham              Other Regional Centres     310         101.           4
#> 5 Mildura              Other Regional Centres     344.        200.           4
#> 6 Sebastopol-Delacombe Ballarat                   345         114            4
```

## Interpreting the outputs

- **Median rent** is the middle weekly rent of new rental agreements in
  a suburb and quarter. It describes what new tenants pay, not existing
  tenants.
- **New lettings** is the number of new rental agreements in that
  quarter. A rent based on few lettings is less reliable.
- **Compare suburbs:** line that sits above another is a more expensive
  suburb. A shorter line means that suburb has no reported data for the
  missing quarters.
- **Top 10 rankings:** the top bar is the most expensive or lease
  expensive. Colours show regions, so you can see whether expensive or
  cheap suburbs cluster in one area.
- **Affordability:** rent is the average of the quarterly median rents
  over the chosen period, so it is an approximation, not an exact
  median. Suburbs with few quarters of data are less reliable.
- **Suburb** can be a single suburb or a group of suburbs, such as
  Carlton-Parkville.
