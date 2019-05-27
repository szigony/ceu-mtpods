# Libraries
library(dplyr)
library(tibble)

# Drinks.csv
drinks <- as.tibble(read.csv("data/Drinks.csv")) %>% 
  mutate(beer_servings = na_if(beer_servings, "?"),
         wine_servings = na_if(wine_servings, "?"),
         spirit_servings = na_if(spirit_servings, "?")) %>% 
  mutate_each(list(as.numeric), ends_with("servings")) %>% 
  mutate_if(is.factor, as.character) %>% 
  mutate(alcohol_per_beer_servings = beer_servings * 12 * 0.05,
         alcohol_per_wine_servings = wine_servings * 5 * 0.12,
         alcohol_per_spirit_servings = spirit_servings * 1.5 * 0.4,
         total_ounces_of_pure_alcohol = alcohol_per_beer_servings + alcohol_per_wine_servings + alcohol_per_spirit_servings,
         total_litres_of_pure_alcohol = total_ounces_of_pure_alcohol * 0.0295) %>% 
  select(country, beer_servings, wine_servings, spirit_servings, total_litres_of_pure_alcohol)

# LifeExpectancy.csv


# CountriesOfTheWorld.xlsx
