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
