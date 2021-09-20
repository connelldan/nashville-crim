# Nashville Target Location for High End Security Systems

In this scenario we will review crime data in Nashville to determine which areas are best to market our expensive security system to.

I will describe the following:

1. Garnering the Data
2. Creating the Report
3. Data Insights

You can review the [dashboard here](https://console.cloud.google.com/marketplace/product/united-states-census-bureau/acs).

## Garnering the Data

- I wanted to gather all the data in code so it's reusable for anyone who wants to collaborate.

- In this [script](/elt/pull-crime-data), you can see I did an extract, load and transformation (ELT) of the [Nashville Crime Data](https://data.nashville.gov/Police/Metro-Nashville-Police-Department-Calls-for-Servic/kwnd-qrrm).

- This data was then loaded into [BigQuery](https://cloud.google.com/bigquery/docs/introduction) as a temporary table. I then used BigQuery SQL to make a few data structure modifications. 

- I then used this data and joined it to the [US Census tract](https://console.cloud.google.com/marketplace/product/united-states-census-bureau/acs) to determine the geographical polygon.

## Creating the Report

- For the report, I [joined the fact table I created to census data](elt/sql/crime_census_join.sql) to look at both crime statistics and income levels per geometric tract in Nashville.

- To gain optimal insights, I created a metric that shows the delta of weighted media income by crime. This will be the key metric to determine the largest impact to communities that crime has.

- I created a [dashboard](https://datastudio.google.com/reporting/b6b7d413-8f17-4343-9aad-39298d053f9e/page/GogaC) in Google Data Studio for a user to use to determine the best location for their marketing campaign. It consists of a heatmap of Nashville to show the highest concentration of weighted median income delta.

## Data Insights

### Scenario

If this high-end security company knows their typical customer makes over $85k a year -- we will use the dashboard to assess which region makes the most sense to spend out marketing dollars.

1. If we use the dashboard and filter down to tracts that make over $85k, we can then rank them based on occurence of crime in the area.

2. We are looking for areas that have a higher rate of crime, assuming there may be an appetite for a security system -- but also that they are able to afford it.

3. After reviewing the data, it seems `Census Tract 134` would be a great candidate to target as it fits our criteria. Another interesting candidate would be `Census Tract 180`, while it is ranked 4th -- the population is considerably large and its income is significantly higher.

### Notes

- It's important to note, I only used data from 2020 and only records that provide geo-spatial information.