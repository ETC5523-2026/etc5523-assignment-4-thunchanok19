## code to prepare `rentals` dataset goes here

library(readr)
library(dplyr)
library(stringr)
library(lubridate)

rentals_raw <- read_csv("data-raw/vic-rents-by-suburb.csv")

rentals <- rentals_raw |> 
  filter(property_type != "All properties") |> 
  filter(suburb != "Group Total") |> 
  filter(!is.na(median_rent), !is.na(new_lettings)) |> 
  mutate(no_of_bedroom = as.integer(str_sub(property_type, 1, 1)),
property_type = str_to_title(str_sub(property_type, 11)))

rentals <- rentals |> 
  mutate(year = as.integer(year(year_ending)),
quarter = factor(quarter(year_ending),
      levels = 1:4,
      labels = c("Q1", "Q2", "Q3", "Q4")))

rentals <- rentals |> 
  select(year, quarter, property_type, no_of_bedroom, new_lettings, 
    median_rent, region, suburb)

usethis::use_data(rentals, overwrite = TRUE)
