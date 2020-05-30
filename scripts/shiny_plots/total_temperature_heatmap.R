library(RColorBrewer)
library(Hmisc)
library(heatmap3)
library(tidyr)
library(tibble)
library(countrycode)

# utilizes the precalculated correlation matrix to assign the
#   mega regions
# parameters:
#   - temp_data : dataframe of the average temperature per country
#   - res : correlation matrix by country for temp_data
# returns:
#   - annotations : dataframe with row names as countries and
#                   a column of mega region names
get_annotation_dataframe <- function(temp_data, res) {
  # assign mega regions
  countries <- row.names(res$r)
  mega_regions <- c()
  for (name in countries) {
    mega_region <-
      temp_data %>%
      filter(region == name) %>%
      pull(mega_region) %>%
      unique()
    mega_regions <- c(mega_regions, mega_region)
  }
  # compile into annotation dataframe
  annotations <- data.frame(mega_regions, row.names = countries,
                            stringsAsFactors = FALSE)

  return(annotations)
}

# calculates the correlation matrix for the given dataset using
#   spearman"s correlation metric
# parameters:
#   - temp_data : dataframe of the average temperature per country
# returns:
#   - res : correlation matrix by country for temp_data
get_correlation_matrix <- function(temp_data) {
  # prepare data for correlation matrix by spreading it into a
  #   data x region matrix with avg_temp values
  country_temp_data <-
    temp_data %>%
    select(date, avg_temp, region) %>%
    spread(key = date, value = avg_temp) %>%
    column_to_rownames(var = "region") %>%
    t()
  # remove any missing values
  country_temp_data <- country_temp_data[complete.cases(country_temp_data), ]

  # get correlation matrix
  res <- rcorr(x = as.matrix(country_temp_data), type = "spearman")

  return(res)
}

# plots a clustered heatmap of dataset 1, average land temperature
#   by country, utilizing Spearman"s correlation and hclust, with
#   the mega regions, combined groups of countries, colored on
# parameters:
#   - temp_data : dataframe of the average temperature per country
all_country_temp_heatmap <- function(temp_data) {
  # assign mega regions
  temp_data <-
    temp_data %>%
    mutate(
      mega_region =
        temp_data %>%
        pull(region) %>%
        countrycode("country.name",
                    "region")
    )
  # remove NA values, basically countries that did not match to continents
  temp_data <- temp_data[complete.cases(temp_data), ]

  # get correlation matrix
  res <- get_correlation_matrix(temp_data)

  # get color palette
  col <- colorRampPalette(c("blue", "cornsilk", "red"))(20)

  # compile into annotation dataframe
  annotations <- get_annotation_dataframe(temp_data, res)

  # get unique mega regions
  unique_mega_regions <-
    annotations %>%
    pull(mega_regions) %>%
    unique()
  # get colors
  colors <- brewer.pal(n = length(unique_mega_regions), name = "Set2")
  # assign each mega region to a color
  names(colors) <- unique_mega_regions
  # assign all regions a mega region color
  mega_regions_colors <-
    annotations %>%
    mutate(mega_regions = colors[mega_regions])

  heatmap3(x = res$r, col = col, symm = TRUE,
           ColSideColors = mega_regions_colors$mega_regions,
           ColSideLabs = "Mega Regions",
           legendfun = function()
             showLegend(legend = c(names(colors), "",
                                   "Negative Correlation",
                                   "No Correlation",
                                   "Positive Correlation"),
                        col = c(colors, "white", "blue", "cornsilk", "red"),
                        cex = 0.75,
                        x = "top"))

}
