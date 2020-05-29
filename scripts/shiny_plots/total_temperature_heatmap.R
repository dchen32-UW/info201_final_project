library(RColorBrewer)
library(Hmisc)
library(heatmap3)
library(tidyr)
library(tibble)
library(countrycode)

get_correlation_matrix <- function(glo_temp) {
  # prepare data for correlation matrix by spreading it into a
  #   data x region matrix with avg_temp values
  country_glo_temp <-
    glo_temp %>%
    select(date, avg_temp, region) %>%
    spread(key = date, value = avg_temp) %>%
    column_to_rownames(var = "region") %>%
    t()
  # remove any missing values
  country_glo_temp <- country_glo_temp[complete.cases(country_glo_temp), ]
  
  # get correlation matrix
  res <- rcorr(as.matrix(country_glo_temp))
  
  return(res)
}

all_country_temp_heatmap <- function(glo_temp) {
  # assign mega regions
  glo_temp <-
    glo_temp %>%
    mutate(
      mega_region =
        glo_temp %>%
        pull(region) %>%
        countrycode("country.name",
                    "region")
    )
  # remove NA values, basically countries that did not match to continents
  glo_temp <- glo_temp[complete.cases(glo_temp), ]

  # get correlation matrix
  res <- get_correlation_matrix(glo_temp)
  
  # get color palette
  col <- colorRampPalette(c("blue", "cornsilk", "red"))(20)

  # assign mega regions
  countries <- row.names(res$r)
  mega_regions <- c()
  for (name in countries) {
    mega_region <-
      glo_temp %>%
      filter(region == name) %>%
      pull(mega_region) %>%
      unique()
    mega_regions <- c(mega_regions, mega_region)
  }
  # compile into annotation dataframe
  annotations <- data.frame(mega_regions, row.names = countries,
                            stringsAsFactors = FALSE)
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
             showLegend(legend = c(names(colors), '',
                                   'Negative Correlation',
                                   'No Correlation',
                                   'Positive Correlation'),
                        col = c(colors, 'white', 'blue', 'cornsilk', 'red'),
                        cex = 0.75,
                        x = 'top'))
  
}
