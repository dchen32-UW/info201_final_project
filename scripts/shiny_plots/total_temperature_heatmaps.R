library(RColorBrewer)
library(Hmisc)
library(heatmap3)
library(tidyr)
library(tibble)
library(countrycode)

# import constants
source("scripts/shiny_utils/constants.R")

# utilizes the precalculated correlation matrix to assign the
#   mega regions
# parameters:
#   - temp_data : dataframe of the average temperature per country
#   - res : correlation matrix by country for temp_data
# returns:
#   - annotations : dataframe with row names as countries and
#                   a column of mega region names
get_annotation_dataframe <- function(temp_data, dist) {
  # assign mega regions
  countries <- row.names(dist)
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
#   correlation metric in the constants.R file in shiny utils'
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
  res <- rcorr(x = as.matrix(country_temp_data),
               type = heatmap_corr_metric)

  return(res)
}

# get the annotation dataframe for mega regions
# parameters:
#   - temp_data : dataframe of the average temperature per country
#   - annotations : base annotation with mega regions and country names
# returns:
#   - group_annotations : contains
#       - dataframe with row names as countries and a column for mega regions
#       - named vector that contains color and group
get_mega_regions <- function(temp_data, annotations) {
  # set empty list of mega region annotations
  group_annotations <- list()
  # get unique mega regions
  unique_groups <-
    annotations %>%
    pull(mega_regions) %>%
    unique()
  # get colors
  colors <- brewer.pal(n = length(unique_groups), name = "Set2")
  # assign each mega region to a color
  names(colors) <- unique_groups
  # add colors to result
  group_annotations$colors <- colors
  # assign all regions a mega region color
  group_colors <-
    annotations %>%
    mutate(colors = colors[mega_regions]) %>%
    rename(groups = mega_regions) %>%
    select(groups, colors)
  row.names(group_colors) <- row.names(annotations)
  # add mega_regions_colors to result
  group_annotations$group_colors <- group_colors

  return(group_annotations)
}

# get the annotation dataframe for the hclust determined groups
# parameters:
#   - temp_data : dataframe of the average temperature per country
#   - annotations : base annotation with mega regions and country names
# returns:
#   - group_annotations : contains
#       - dataframe with row names as countries and a column for hclust clusters
#       - named vector that contains color and group
get_group_regions <- function(dist, annotations) {
  # calculate distance
  res_dist <- as.dist(1 - cor(t(dist), use = "pa"))
  # perform clustering
  res_hclust <- hclust(res_dist, method = "ward.D2")
  # get clusters with a cut in the tree at 0.5
  res_cutree <- cutree(res_hclust, h = 0.5)
  # set empty list of group annotations
  group_annotations <- list()
  # get groups
  unique_groups <- unique(res_cutree)
  # get colors
  colors <- brewer.pal(n = length(unique_groups), name = "Set2")
  # assign each mega region to a color
  names(colors) <- unique_groups
  # rename colors
  new_names <- c()
  for (name in names(colors)) {
    new_names <- c(new_names, paste("Group", name))
  }
  names(colors) <- new_names
  # add colors to result
  group_annotations$colors <- colors
  # assign all regions a mega region color
  group_colors <- annotations
  group_colors["groups"] <- row.names(annotations)
  group_colors <-
    group_colors %>%
    mutate(groups = paste("Group", res_cutree[groups])) %>%
    mutate(colors = colors[groups]) %>%
    select(groups, colors)
  row.names(group_colors) <- row.names(annotations)
  # add groups_colors to result
  group_annotations$group_colors <- group_colors

  return(group_annotations)
}

# get the annotation dataframe for any group, this is more of a subsetted
#   copy paste of the below but is useful for outputting annotations to outside
#   sources without the initial code in all_country_temp_corrmap
# parameters:
#   - temp_data : dataframe of the average temperature per country
#   - annotations : base annotation with mega regions and country names
# returns:
#   - group_annotations : contains
#       - dataframe with row names as countries and a column for requested
#         groups and the associated colors
get_all_temp_corr_groups <- function(temp_data, anno_group) {
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

  # compile into annotation dataframe
  annotations <- get_annotation_dataframe(temp_data, res$r)

  # do clustering and assing groups based on dendrograms
  # get group annotations and colors
  if (anno_group == "Mega Regions") {
    group_annotations <- get_mega_regions(temp_data, annotations)
  } else if (anno_group == "Groups") {
    group_annotations <- get_group_regions(res$r, annotations)
  }

  return(group_annotations)
}

# plots a clustered heatmap of dataset 1, average land temperature
#   by country, utilizing correlation metric in the constants.R file
#   in shiny utils' and hclust, with the mega regions, combined groups
#   of countries, colored on
# parameters:
#   - temp_data : dataframe of the average temperature per country
#   - anno_group : groups of countries to color on
all_country_temp_corrmap <- function(temp_data, anno_group) {
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
  col <- colorRampPalette(c(heatmap_min, heatmap_middle, heatmap_max))(20)

  # compile into annotation dataframe
  annotations <- get_annotation_dataframe(temp_data, res$r)

  # do clustering and assing groups based on dendrograms
  # get group annotations and colors
  if (anno_group == "Mega Regions") {
    group_annotations <- get_mega_regions(temp_data, annotations)
  } else if (anno_group == "Groups") {
    group_annotations <- get_group_regions(res$r, annotations)
  }
  colors <- group_annotations$colors
  colsidecolors <- group_annotations$group_colors$colors

  heatmap3(x = res$r, col = col, symm = TRUE,
           ColSideColors = colsidecolors,
           ColSideLabs = anno_group,
           method = "ward.D2",
           legendfun = function()
             showLegend(legend = c(names(colors), "",
                                   "Negative Correlation",
                                   "No Correlation",
                                   "Positive Correlation"),
                        col = c(colors,
                                background_color,
                                heatmap_min,
                                heatmap_middle,
                                heatmap_max),
                        cex = 0.75,
                        x = "top"))
}
