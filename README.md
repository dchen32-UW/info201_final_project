---
title: "INFO 201BB - Group 3"
author: "Daniel Chen, Grace Teebken, Tanner Lauzon, Kellen Maier"
date: "05/06/2020"
output: html_document
---

## Domain of Interest - **Climate Change**
We are interested in **Climate Change** because of its relevance to the world of today and tomorrow. How we choose to act against it will have major impact on the enviornment of the future as such, we are interested in how we can best utilize data to visualize its impacts and potential solutions.

Below we list a few examples of previous data driven projects relevant to **Climate Change**:

- [**Comprehensive overview of climate change and the impact of technology**](http://worrydream.com/ClimateChange/)
    - Their GitHub page can be found [here](https://github.com/worrydream/ClimateChange). It gives a decently in-depth overview of current funding within the United States, and the impacts of different energy sources. Furthermore, it provides different programming languages and techologies to model our climate and how different changes can worsen or benefit it. It also includes a lot of interesting visualizations of the different datasets they have gathered, an example is shown below:
    - ![image of electricity source and resulting energy comsumption](imgs/project_1_for_readme.png)
- [**Impacts of natural disasters, particularly their mortality rates**](https://ourworldindata.org/natural-disasters)
    - Their Github page can be found [here](https://github.com/owid), it does not exactly cover what they have in their article, but does provide code they used to make various plots that they included. It utilizes large datasets to cover the impact of natural disasters across different countries and their mortality rates in each. Furthermore, it provides some interesting information in the news coverage of different types of natural disasters along with the average deaths needed to cause a *"Breaking News"* article.
- [**Historical and future projections of global temperatures**](https://www.impactlab.org/) 
    - This is a project that is trying to map socioeconomic factors against climate change to understand what impacts climate change will have on society at the local level. They aim to offer climate change risk information to policymakers and business leaders. They have not provided the code they used in their plots, but they provided their datasets, which include data on county-level damages to economic sectors.

Based on our knowledge of **Climate Change** and the projects mentioned above, we propose the following questions:

- How is climate change impacting the ***economy*** of different countries, are there factors that make some countries more susceptible to having a larger carbon footprint?
    - By looking at both economy and climate data with a country by year dataset, we can overlay changes in economy and changes in climate, perhaps via a map with color map based on income/GDP and climate change factors. We can then examine the correlation between each variable from both an economy and climate dataset to examine what specific factors correlate the best with each other. This will allow us to see how the worsening climate impacts the global economy, if a positive relationship is found (worse climate correlate with worse economy) we can raise the stakes in the climate change discussion.
- How are ***natural disasters*** impacting or being impacted by climate change, how have their natural patterns/fluctuations change in accordance to the change in global environment?
    - We know that climate change is impacting the world, but exactly how and what it is doing is not particularly clear. As such we hope to integrate multiple datasets that cover different natural disasters, their frequency, and their impact and correlate that with climate change factors, such as change in temperature and sea level to examine possible correlation.
- What are the ***trackable by-products*** of climate change (e.g. CO2 emissions) and what factors correlate to such, as in are there risk factors involved?
    - By finding specific empirical measurments that correlate the best with climate change, we can hint at possible causual relationships and find better ways to empircally determine the level of climate change. We hope to examine the many measurments done on a country that could potentially impact the enviornment (e.g. CO2 emissions, energy production, etc.) and correlate that with the impacts of climate change, such as change in temp, to see which of these factors measured could be a potential risk factor (i.e. more negatively impact climate change).

## Finding Data
To help us to better understand this domain and answer the questions in the previous section we found the following datasets:

- [**Temperature data with various scales**](https://www.kaggle.com/berkeleyearth/climate-change-earth-surface-temperature-data)
    - This dataset is from kaggle, although the original raw data was gathered from [Berkely Earth data](http://berkeleyearth.org/data/). All of the datasets from this source are stored in `data/kaggle_global_temp/`, except for *GlobalLandTemperaturesByCity.csv* as it is around ~500 MB so we can not upload it to our GitHub since it is over the 50 MB upload size limit. In addition, we do not plan on using it as there is a smaller alternative, *GlobalLandTemperaturesByMajorCity.csv*, that provides similar data without the issue of a massive file size.
    - We can use this data is our *source of truth* for climate change impact, we can utilize this change in temp for the correlations described in the questions above. If we want to see how a certain factor or action correlates with climate change we can attempt to correlate it via the following data. The nice thing about this data is that it provides data at the major city, state, country, and global level so we can accomadate data that describes possible risk factors (e.g. CO2 emissions) that are on different levels, perhaps some are on a country level while others are on a state level. For example, we could correlate CO2 emissions and energy production data on a country level, with the country level global temperature data from this source, this would help us answer our question _"What are the ***trackable by-products*** of climate change (e.g. CO2 emissions) and what factors correlate to such, as in are there risk factors involved?"_ as it would allow us to identify potential risk factors via their correlation with the global temperature data.
    - The source consists of four datasets (excluding *GlobalLandTemperaturesByCity.csv*):
        - Global Land and Ocean-and-Land Temperatures *(GlobalTemperatures.csv)*
            - Provides temperature measurements from 1750 onward for average land temperature and 1850 onward for average land + water temperature resulting in a total of **3192 values**
            - Consists of **9 columns**:
                - **dt** - date of measurement
                - **LandAverageTemperature** - global average land temperature in celsius
                - **LandAverageTemperatureUncertainty** - the 95% confidence interval around the average
                - **LandMaxTemperature** - global average maximum land temperature in celsius
                - **LandMaxTemperatureUncertainty** - the 95% confidence interval around the maximum land temperature
                - **LandMinTemperature** - global average minimum land temperature in celsius
                - **LandMinTemperatureUncertainty** - the 95% confidence interval around the minimum land temperature
                - **LandAndOceanAverageTemperature** - global average land and ocean temperature in celsius
                - **LandAndOceanAverageTemperatureUncertainty** - the 95% confidence interval around the global average land and ocean temperature
        - Global Average Land Temperature by Country *(GlobalLandTemperaturesByCountry.csv)*
            - Provides temperature measurements from 1743 on the average land temperature of each country on a monthly basis resulting in a total of **577,464 values**
            - Consists of **4 columns**:
                - **dt** - date of measurement
                - **AverageTemperature** - country average land temperature in celsius
                - **AverageTemperatureUncertainty** - the 95% confidence interval around the average
                - **Country** - name of the country being measured
        - Global Average Land Temperature by State *(GlobalLandTemperaturesByState.csv)*
            - Provides temperature measurements from 1743, though some states start later, on the average land temperature of each state on a monthly basis resulting in a total of **645,675 values**
            - Consists of **5 columns**:
                - **dt** - date of measurement
                - **AverageTemperature** - country average land temperature in celsius
                - **AverageTemperatureUncertainty** - the 95% confidence interval around the average
                - **State** - name of the state being measured
                - **Country** - name of the state's country
        - Global Land Temperatures By Major City *(GlobalLandTemperaturesByMajorCity.csv)*
            - Provides temperature measurements from 1743, though some cities start later, on the average land temperature of each major city on a monthly basis resulting in a total of **239,177 values**
            - Consists of **7 columns**:
                - **dt** - date of measurement
                - **AverageTemperature** - country average land temperature in celsius
                - **AverageTemperatureUncertainty** - the 95% confidence interval around the average
                - **City** - name of the major city being measured
                - **Country** - name of the city's country
                - **Latitude** - latitude of the city
                - **Longitude** - longitude of the city
- [**Count and economic damage of natural disasters**](https://www.kaggle.com/dataenergy/natural-disaster-data#number-of-natural-disaster-events.csv)
    - This is also a dataset from kaggle, though the original data is a subset from [here](https://ourworldindata.org/natural-disasters). It covers the following natural disasters, 'Drought', 'Earthquake', 'Extreme temperature', 'Extreme weather', 'Flood', 'Impact', 'Landslide', 'Mass movement (dry)', 'Volcanic activity' and 'Wildfire'. It also has a sum of all of the natural disasters per year for both economic information and count. This data is stored in `data/kaggle_natural_disaster/`.
    - We can utilize this dataset to identify how natural disasters are being impacted by climate change via correlation metrics. As this dataset covers variety of natural disasters we can examine which best correlates with natural disasters. We could perhaps also use it's previous data, as in years before a certain cutoff in which the climate began to rapidly change, and predict it's supposed trends in the futures and examine how it has actually varied from it's supposed trend and examine if that variance correlates with climate change, the global temp data from the first dataset mentioned. This could help us answer *"How are natural disasters impacting or being impacted by climate change, how have their natural patterns/fluctuations change in accordance to the change in global environment?"*
    - The source consists of two datasets:
        - Number of natural disasters per year *(number-of-natural-disaster-events.csv)*
            - Gives the count of different types of natural disasters per year resulting in a total of **828 values**
            - Consists of **4 columns**
                - **Entity** - type of natural disaster
                - **Code** - is null for every observation
                - **Year** - the year the natural disaster data is referring to
                - **Number.of.reported.natural.disasters..reported.disasters.** - the count of the reports for the specified natural disaster
        - Economic damage associated with a specific type of natural disaster per year *(economic-damage-from-natural-disasters.csv)*
            - Provides the economic damage, in USD, of different types of natural disasters per year resulting in a total of **561 values**
            - Consists of **4 columns**
                - **Entity** - type of natural disaster
                - **Code** - is null for every observation
                - **Year** - the year the natural disaster data is referring to
                - **Total.economic.damage.from.natural.disasters..US..** - the sum of economic damages caused by the specified natural disaster in USD
- [**Global CO2 level on a monthly basis**](https://datahub.io/core/co2-ppm)
    - This dataset is from datahub.io and provides, seasonally, corrected and raw data of both the global CO2 level, measured as a mole fraction and converted to ppm (parts per million), and the CO2 level on Mauna Loa, as there's a main sensor and research lab there. The data is stored at `data/datahub_co2_ppm/`. The original raw data is sourced from the US Government's Earth System Research Laboratory, Global Monitoring Division, the global data is from several marine sites.
    - We can use this dataset to answer our last question _"What are the ***trackable by-products*** of climate change (e.g. CO2 emissions) and what factors correlate to such, as in are there risk factors involved?"_ Specifically, we can attempt to correlate these CO2 levels to other risk factors that could contribute to climate change. In addition we can see if this data correlates well with the global temp data from the first dataset mentioned. If so then we should be able to claim that these CO2 levels are another good marker of climate change and attempt correlations between CO2 levels and risk factors to identify the major sources of climate change.
    - This source consists of two datasets:
        - Mauna Loa CO2 levels *(co2_mm-mlo_csv.csv)*
            - This covers the raw average, interpolated and trend based/seasonally corrected values for CO2 levels, as measured at Mauna Loa resulting in a total of **727 values**
            - Consists of **6 columns**:
                - **Date** - the date of measurement
                - **Decimal.Date** - the data in a percentage of a year format
                - **Average** - the raw average ppm per month, will be -99.99 if the month is missing (i.e. has absolutely no data)
                - **Interpolated** - filled in version with interpolated values for the missing months
                - **Trend** - seasonally corrected CO2 levels, removes the seasonal ups and downs that the interpolated and average graphs have
                - **Number.of.Days** - the number of days the average column data was derived from, will be -1 for no days
        - Global CO2 Levels *(co2_mm-gl_csv.csv)*
            - This covers the raw average, interpolated and trend based/seasonally corrected values for global CO2 levels resulting in a total of **463 values**
            - Consists of **4 columns**:
                - **Date** - the date of measurement
                - **Decimal.Date** - the data in a percentage of a year format
                - **Average** - the raw average ppm per month
                - **Trend** - seasonally corrected CO2 levels, removes the seasonal ups and downs that the interpolated and average graphs have
    