# Victorian rents by suburb

Median weekly rents and number of new lettings (new rental agreements)
by suburb, property type, number of bedrooms and quarter. Cleaned from
the raw CSV in `data-raw/`: aggregate rows ("All properties" and "Group
Total") and rows with missing values were removed.

## Usage

``` r
rentals
```

## Format

A data frame with 86,368 rows and 8 columns:

- year:

  Calendar year of the quarter (integer)

- quarter:

  Calendar quarter, a factor with levels Q1 to Q4

- property_type:

  Type of property, either "Flat" or "House"

- no_of_bedroom:

  Number of bedrooms (integer)

- new_lettings:

  Number of new rental agreements

- median_rent:

  Median weekly rent for new lettings (dollars)

- region:

  Region name

- suburb:

  Suburb or suburb group name

## Source

Victorian Department of Families, Fairness and Housing (DFFH) Rental
Report, <https://www.dffh.vic.gov.au/publications/rental-report>, as
compiled at <https://publicdata.au/d/vic-rents-by-suburb/>.
