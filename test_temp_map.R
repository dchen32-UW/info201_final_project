library(viridis)
library(ggplot2)
library(plotly)
library(tidyr)
library(dplyr)

# plot temperature on world map
# load in map coordinates
world_data <- map_data("world")
# load in temperature by country
df <- read.csv("data/kaggle_global_temp/GlobalLandTemperaturesByCountry.csv",
               stringsAsFactors = FALSE)
# add year and month
df <- df %>% mutate(year = as.integer(substring(dt, 1, 4)))
df <- df %>% mutate(month = as.integer(substring(dt, 6, 7)))
# rename it
colnames(df) <- c("date", "avg_temp", "avg_temp_se", "region", "year", "month")

# "Antigua And Barbuda" <- assign Barbuda and create new copy and rename Antigua
# "Saint Vincent And The Grenadines" <- assign Saint Vincent and create new copy and rename Grenadines
# "Saint Kitts And Nevis" <- assign Saint Kitts and create new copy and rename Nevis
# "Trinidad And Tobago" <-  assign Trinidad and create new copy and rename Tobago
df <- df %>% mutate(region = ifelse(region == "Bosnia And Herzegovina",
                                    "Bosnia and Herzegovina", region))
df <- df %>% mutate(region = ifelse(region == "British Virgin Islands",
                                    "Virgin Islands", region))
df <- df %>% mutate(region = ifelse(region == "Burma", "Myanmar", region))
df <- df %>% mutate(region = ifelse(region == "Côte D'Ivoire", "Ivory Coast", region))
df <- df %>% mutate(region = ifelse(region == "Congo (Democratic Republic Of The)",
                                    "Democratic Republic of the Congo", region))
df <- df %>% mutate(region = ifelse(region == "Congo", "Republic of Congo", region))
df <- df %>% mutate(region = ifelse(region == "Curaçao", "Curacao", region))
df <- df %>% mutate(region = ifelse(region == "Falkland Islands (Islas Malvinas)",
                                    "Falkland Islands", region))
df <- df %>% mutate(region = ifelse(region == "Federated States Of Micronesia",
                                    "Micronesia", region))
df <- df %>% mutate(region = ifelse(region == "Guinea Bissau", "Guinea-Bissau", region))
df <- df %>% mutate(region = ifelse(region == "Heard Island And Mcdonald Islands",
                                    "Heard Island", region))
df <- df %>% mutate(region = ifelse(region == "Isle Of Man", "Isle of Man", region))
df <- df %>% mutate(region = ifelse(region == "Palestina", "Palestine", region))
df <- df %>% mutate(region = ifelse(region == "Saint Barthélemy",
                                    "Saint Barthelemy", region))
df <- df %>% mutate(region = ifelse(region == "Saint Pierre And Miquelon",
                                    "Saint Pierre and Miquelon", region))
df <- df %>% mutate(region = ifelse(region == "Sao Tome And Principe",
                                    "Sao Tome and Principe", region))
df <- df %>% mutate(region = ifelse(region == "Timor Leste", "Timor-Leste", region))
df <- df %>% mutate(region = ifelse(region == "Turks And Caicas Islands",
                                    "Turks and Caicos Islands", region))
df <- df %>% mutate(region = ifelse(region == "United States", "USA", region))
df <- df %>% mutate(region = ifelse(region == "United Kingdom", "UK", region))
# define minimalistic theme
blank_theme <- theme_bw() + 
  theme(
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
  )

# filter for 2012 January data
df_subset <- df %>% filter(year == 2012) %>% filter(month == 1)
# clean it up
df_subset <- df_subset[complete.cases(df_subset), ]
# join to country lat and long dataset
world_data_subset <- left_join(world_data, df_subset)
# plot January 2012 data
ggplot(data = world_data_subset) + 
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = avg_temp),
    color = "white",
    size = .1
  ) + 
  scale_fill_continuous(low = "Blue", high = "Red") + 
  labs(fill = "Average Temperature (˚C)", title = "Average Temperature January 2012") + 
  blank_theme

# filter for 2012 data
df_subset <-
  df %>%
  filter(year == 2012) %>%
  group_by(region) %>%
  summarize(avg_temp = mean(avg_temp, na.rm = TRUE))
# clean it up
df_subset <- df_subset[complete.cases(df_subset), ]
# join to country lat and long dataset
world_data_subset <- left_join(world_data, df_subset)
# plot January 2012 data
ggplot(data = world_data_subset) + 
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = avg_temp),
    color = "white",
    size = .1
  ) + 
  scale_fill_continuous(low = "Blue", high = "Red") + 
  labs(fill = "Average Temperature (˚C)", title = "Average Temperature 2012") + 
  blank_theme

# filter for 1912 data
df_subset <-
  df %>%
  filter(year == 1912) %>%
  group_by(region) %>%
  summarize(avg_temp = mean(avg_temp, na.rm = TRUE))
# clean it up
df_subset <- df_subset[complete.cases(df_subset), ]
# join to country lat and long dataset
world_data_subset <- left_join(world_data, df_subset)
# plot January 1912 data
ggplot(data = world_data_subset) + 
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = avg_temp),
    color = "white",
    size = .1
  ) + 
  scale_fill_continuous(low = "Blue", high = "Red") + 
  labs(fill = "Average Temperature (˚C)", title = "Average Temperature 1912") + 
  blank_theme

# plot the change between 2012 and 1912
# filter for 1912 data
df_subset_1912 <-
  df %>%
  filter(year == 1912) %>%
  group_by(region) %>%
  summarize(avg_temp_1912 = mean(avg_temp, na.rm = TRUE))
# filter for 2012 data
df_subset_2012 <-
  df %>%
  filter(year == 2012) %>%
  group_by(region) %>%
  summarize(avg_temp_2012 = mean(avg_temp, na.rm = TRUE))
# join them together
df_subset <- inner_join(df_subset_2012, df_subset_1912, by = "region")
df_subset <- df_subset %>% mutate(temp_change = avg_temp_2012 - avg_temp_1912)
# clean it up
df_subset <- df_subset[complete.cases(df_subset), ]
# join to country lat and long dataset
world_data_subset <- left_join(world_data, df_subset)
# plot January 1912 data
ggplot(data = world_data_subset) + 
  geom_polygon(
    mapping = aes(x = long, y = lat, group = group, fill = temp_change),
    color = "white",
    size = .1
  ) + 
  scale_fill_continuous(low = "Grey", high = "Red") + 
  labs(fill = "Average Temperature (˚C)",
       title = "Change in Average Temperature from 1912 to 2012") + 
  blank_theme