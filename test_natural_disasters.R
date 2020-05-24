library(viridis)
library(ggplot2)
library(plotly)
library(tidyr)
library(dplyr)

# testing reading in natural disaster dataset and doing prelim plots
# load in dataset
df <- read.csv("data/kaggle_natural_disaster/number-of-natural-disaster-events.csv",
               stringsAsFactors = FALSE)
# remove "Code" column
df <- select(df, -Code)
# rename columns
colnames(df) <- c("disaster", "year", "count")
# check dimensions (828, 3)
dim(df)
# remove any rows with NA
df <- df[complete.cases(df), ]
# check dimensions again (828, 3)
dim(df)

# prelim ggplot count by year with disaster colored
# scatter plot
ggplot(data = df) +
  geom_point(mapping = aes(x = year, y = count, color = disaster))
# trend line
ggplot(data = df) +
  geom_smooth(mapping = aes(x = year, y = count, color = disaster))
# trend line interactive
trend_plot <- ggplot(data = df) +
  geom_smooth(mapping = aes(x = year, y = count, color = disaster))
ggplotly(trend_plot)

# all natural disasters may not be a useful measurment unless
#   we want to find out the percentage of each natural disaster
#   tho we really don't need all natural disasters for that either
# testing filtering out all natural disasters in plots
# check dimensions (709, 3)
df %>% filter(disaster != "All natural disasters") %>% dim()
# do the same plots as before, count by year with disaster colored
# scatter plot
df %>%
  filter(disaster != "All natural disasters") %>%
  ggplot() +
  geom_point(mapping = aes(x = year, y = count, color = disaster))
# trend line
df %>%
  filter(disaster != "All natural disasters") %>%
  ggplot() +
  geom_smooth(mapping = aes(x = year, y = count, color = disaster))
# binned 2d plot by disaster
df %>%
  filter(disaster != "All natural disasters") %>%
  ggplot() +
  geom_bin2d(mapping = aes(x = year, y = count, color = disaster)) +
  facet_wrap(~disaster)

# ------------------

# testing adding economic damage
df_econ <- read.csv("data/kaggle_natural_disaster/economic-damage-from-natural-disasters.csv",
                    stringsAsFactors = FALSE)
# remove "Code" column
df_econ <- select(df_econ, -Code)
# rename columns
colnames(df_econ) <- c("disaster", "year", "damage")
# check dimensions (561, 3)
dim(df_econ)
# remove any rows with NA
df_econ <- df_econ[complete.cases(df_econ), ]
# check dimensions again (561, 3)
dim(df_econ)

# combine the two
df_combined <- left_join(df_econ, df, by = c("year", "disaster"))
# check the dimensions (561, 4)
dim(df_combined)

# plot economic damage against counts of each disaster
df_combined %>%
  ggplot(mapping = aes(x = damage, y = count, color = disaster)) +
  geom_point(alpha = 0.3) +
  geom_smooth() +
  facet_wrap(~disaster)

df_combined %>%
  filter(disaster != "All natural disasters") %>%
  ggplot(mapping = aes(x = damage, y = count, color = disaster)) +
  geom_point(alpha = 0.3) +
  geom_smooth() +
  facet_wrap(~disaster)

# damage by year with count colored on
df_combined %>%
  filter(disaster != "All natural disasters") %>%
  ggplot() +
  geom_point(mapping = aes(x = year, y = damage, color = count)) +
  facet_wrap(~disaster) +
  scale_color_viridis(option = "A")

# count by year with damage colored on and different color palette
df_combined %>%
  filter(disaster != "All natural disasters") %>%
  ggplot() +
  geom_point(mapping = aes(x = year, y = count, color = damage)) +
  facet_wrap(~disaster) +
  scale_color_gradientn(colours = rainbow(5))

# ------

# plot summary statistics
df_combined <- df_combined %>% mutate(impact = damage / count)
# looking at size based on mean ratio damage / count meaning larger circles have
# higher impact, essentially the disaster has caused more damage
# with a smaller count
# smaller circles have lower impact, essentially the disaster
# has caused less damage
# with a larger count
df_combined %>%
  filter(disaster != "All natural disasters")  %>%
  group_by(disaster) %>%
  summarize(mean_damage = mean(damage),
            mean_counts = mean(count),
            mean_impact = mean(impact)) %>%
  ggplot() +
  geom_smooth(mapping = aes(x = mean_damage,
                            y = mean_counts),
              color = 'grey', alpha=0.2) +
  geom_point(mapping = aes(x = mean_damage,
                           y = mean_counts,
                           color=disaster,
                           size = mean_impact))

# we can also plot this ratio on the axis as well, with counts and damage
# by the impact
# count by impact
df_combined %>%
  filter(disaster != "All natural disasters")  %>%
  group_by(disaster) %>%
  summarize(mean_damage = mean(damage),
            mean_counts = mean(count),
            mean_impact = mean(impact)) %>%
  ggplot() +
  geom_smooth(mapping = aes(x = mean_impact,
                            y = mean_counts),
              color = 'grey', alpha=0.2) +
  geom_point(mapping = aes(x = mean_impact,
                           y = mean_counts,
                           color=disaster,
                           size = mean_damage))

# damage by impact
df_combined %>%
  filter(disaster != "All natural disasters")  %>%
  group_by(disaster) %>%
  summarize(mean_damage = mean(damage),
            mean_counts = mean(count),
            mean_impact = mean(impact)) %>%
  ggplot() +
  geom_smooth(mapping = aes(x = mean_impact,
                            y = mean_damage),
              color = 'grey', alpha=0.2) +
  geom_point(mapping = aes(x = mean_impact,
                           y = mean_damage,
                           color=disaster,
                           size = mean_counts))

# joining temperature dataset
df_temp <- read.csv('data/kaggle_global_temp/GlobalTemperatures.csv',
                    stringsAsFactors = FALSE)
# only select relevant columns
df_temp <- df_temp %>% select(dt, LandAverageTemperature)
# check dimensions (3192, 10)
dim(df_temp)
# remove any rows with NA
df_temp <- df_temp[complete.cases(df_temp), ]
# check dimensions again (1992, 3)
dim(df_temp)
# group by year
df_temp <- df_temp %>% mutate(year = as.integer(substring(dt, 1, 4)))
df_temp_by_year <- df_temp %>%
  group_by(year) %>%
  summarize(mean_lo_temp = mean(LandAndOceanAverageTemperature, na.rm = TRUE))
# join with econ+count dataset
df_combined_temp <- left_join(df_combined, df_temp_by_year, by=c('year'))
# check dimensions (561, 6)
dim(df_combined_temp)
# remove any rows with NA
df_combined_temp <- df_combined_temp[complete.cases(df_combined_temp), ]
# check dimensions again (534, 6)
dim(df_combined_temp)
# count by temp with damage colored on
df_combined_temp %>%
  filter(disaster != "All natural disasters") %>%
  ggplot() +
  geom_point(mapping = aes(x = mean_lo_temp, y = count, color = damage)) +
  facet_wrap(~disaster) +
  scale_color_gradientn(colours = rainbow(5))