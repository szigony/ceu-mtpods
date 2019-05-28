# Libraries
library(dplyr)
library(tibble)
library(stringr)
library(readxl)

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
life_expectancy <- as.tibble(read.csv("data/LifeExpectancy.csv")) %>% 
  mutate(country = CountryDisplay,
         year = YearCode,
         metric = GhoDisplay,
         region = RegionDisplay,
         income_group = WorldBankIncomeGroupDisplay,
         sex = SexDisplay,
         value = Numeric) %>% 
  select(country, year, metric, region, income_group, sex, value) %>% 
  mutate(income_group = na_if(str_replace(str_replace(income_group, "_income", ""), "_", " "), "")) %>% 
  mutate_each(list(as.character), country)
unique(life_expectancy$metric)

# CountriesOfTheWorld.xls
countries <- read_excel("data/CountriesOfTheWorld.xls", sheet = "Sheet1", range = "A4:P232")
names(countries) <- paste(names(countries), countries[1, ], sep = " ")

countries <- countries %>% 
  slice(2:n()) %>% 
  mutate(country = `Country NA`,
         population = `Population NA`,
         area = as.numeric(`Area sq. mi.`),
         population_density = as.numeric(`Pop. Density per sq. mi.`),
         coast_area_ratio = as.numeric(`Coastline coast/area ratio`),
         net_migration = `Net migration NA`,
         infant_mortality_per_1000_births = as.numeric(`Infant mortality per 1000 births`),
         gdp_per_capita = as.numeric(`GDP $ per capita`),
         literacy = as.numeric(`Literacy %`) / 100,
         phones_per_1000 = as.numeric(`Phones per 1000`),
         arable = as.numeric(`Arable %`) / 100,
         crops = as.numeric(`Crops %`) / 100,
         other = as.numeric(`Other %`) / 100,
         birthrate = `Birthrate NA`,
         deathrate = `Deathrate NA`) %>% 
  select(country, population, area, population_density, coast_area_ratio, net_migration, infant_mortality_per_1000_births,
         gdp_per_capita, literacy, phones_per_1000, arable, crops, other, birthrate, deathrate)
