# Libraries
library(dplyr)
library(tibble)
library(stringr)
library(readxl)

## Drinks.csv
# Calculate total liters of pure alcohol
# 1 ounce = 0.0295 liter
# Beer serving: 12 ounces, 5% alcohol
# Wine serving: 5 ounces, 12% alcohol
# Spirit serving: 1.5 ounces, 40% alcohol
# Omit the NA values so that it wouldn't skew the analysis
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
         total_liters_of_pure_alcohol = total_ounces_of_pure_alcohol * 0.0295) %>% 
  select(country, beer_servings, wine_servings, spirit_servings, total_liters_of_pure_alcohol) %>% 
  na.omit()

## LifeExpectancy.csv
# Omit the rows where the income_group is unknown
# Convert income_group, region and sex to factors
# Transform "Life expectancy at age 60 (years)" to life expectancy by adding 60
# Calculate the average life expectancy across the various metrics for both sexes and combined
lifetime <- as.tibble(read.csv("data/LifeExpectancy.csv")) %>% 
  mutate(country = CountryDisplay,
         year = YearCode,
         metric = GhoDisplay,
         region = RegionDisplay,
         income_group = WorldBankIncomeGroupDisplay,
         sex = SexDisplay,
         value = Numeric) %>% 
  select(country, year, metric, region, income_group, sex, value) %>% 
  filter(income_group != "") %>% 
  mutate(income_group = as.factor(na_if(str_replace(str_replace(income_group, "_income", ""), "_", " "), ""))) %>% 
  mutate_each(list(as.character), country) %>% 
  mutate(value = ifelse(metric == "Life expectancy at age 60 (years)", value + 60, value)) %>% 
  group_by(country, year, sex, region, income_group) %>% 
  summarise(avg_life_expectancy = mean(value)) %>% 
  ungroup()

## CountriesOfTheWorld.xls
# Read the specified range from the Excel file
# The headers flow through to the second line, merge them with the first
countries <- read_excel("data/CountriesOfTheWorld.xls", sheet = "Sheet1", range = "A4:P232")
names(countries) <- paste(names(countries), countries[1, ], sep = " ")

# Convert all variables to the appropriate data type
# literacy, arable, crops and other are stored as percentages
countries <- countries %>% 
  slice(2:n()) %>% 
  mutate(country = `Country NA`,
         population = `Population NA`,
         area = as.numeric(`Area sq. mi.`),
         population_density = as.numeric(`Pop. Density per sq. mi.`),
         coast_area_ratio = as.numeric(`Coastline coast/area ratio`),
         net_migration = `Net migration NA`,
         infant_mortality_rate = as.numeric(`Infant mortality per 1000 births`),
         gdp_per_capita = as.numeric(`GDP $ per capita`),
         literacy = as.numeric(`Literacy %`) / 100,
         phones = as.numeric(`Phones per 1000`),
         arable = as.numeric(`Arable %`) / 100,
         crops = as.numeric(`Crops %`) / 100,
         other = as.numeric(`Other %`) / 100,
         birthrate = `Birthrate NA`,
         deathrate = `Deathrate NA`) %>% 
  select(country, population, area, population_density, coast_area_ratio, net_migration, infant_mortality_rate,
         gdp_per_capita, literacy, phones, arable, crops, other, birthrate, deathrate)
