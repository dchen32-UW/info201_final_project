library(ggplot2)
library(plotly)

# testing reading in natural disaster dataset and doing prelim plots
# load in dataset
df <- read.csv("data/kaggle_natural_disaster/number-of-natural-disaster-events.csv")
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

