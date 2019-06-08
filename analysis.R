# Libraries
library(corrr)
library(ggplot2)

# Load the clean datasets
source("data-preparation.R")

# Merge the datasets
data <- drinks %>% 
  inner_join(lifetime, by = "country") %>% 
  inner_join(countries, by = "country") %>% 
  mutate(country = as.factor(country)) %>% 
  arrange(country, year)

# Remove individual datasets
rm(drinks, lifetime, countries)

# Calculate correlation between expected lifetime and total liters of pure alcohol
res <- data %>% 
  select_if(is.numeric) %>%  
  correlate() %>% 
  focus(avg_life_expectancy)

res %>% 
  filter(rowname == "total_liters_of_pure_alcohol")

# Find factors that are highly correlated to the expected lifetime
res %>% 
  mutate(rowname = reorder(rowname, avg_life_expectancy),
         sign = ifelse(avg_life_expectancy >= 0, "positive", "negative")) %>% 
  ggplot(aes(x = rowname, y = avg_life_expectancy, fill = sign)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = c("positive" = "palegreen3", "negative" = "indianred2")) +
    labs(y = "Correlation with expected lifetime", x = "Factor") +
    coord_flip() +
    theme(legend.position = "none")

ggsave("correlation-with-expected-lifetime.png")
