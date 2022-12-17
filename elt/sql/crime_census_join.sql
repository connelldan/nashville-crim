with total_crimes_geo as
(
SELECT 
  geo_id, 
  count(1) total_crimes 
FROM 
  `connelld-app-services.nashville_data.crime_census` 
where 
  extract(year from Call_Received) = 2020 
group by 
  geo_id
  )
--
select 
  ct.state_fips_code, 
  ct.county_fips_code, 
  c.county_name, 
  ct.tract_ce, 
  ct.geo_id, 
  ct.tract_name, 
  ct.lsad_name, 
  ct.internal_point_lat, 
  ct.internal_point_lon, 
  ct.internal_point_geo, 
  ct.tract_geom, 
  acs.total_pop, 
  acs.households, 
  acs.male_pop, 
  acs.female_pop, 
  acs.median_age, 
  acs.median_income, 
  acs.income_per_capita, 
  acs.gini_index, 
  acs.owner_occupied_housing_units_median_value, 
  acs.median_rent, 
  acs.percent_income_spent_on_rent, 
  x.total_crimes, 
  SAFE_DIVIDE(x.total_crimes, acs.total_pop) as crimes_per_capita, 
  SAFE_MULTIPLY(
    acs.median_income, 
    1 - SAFE_DIVIDE(x.total_crimes, acs.total_pop)
  ) as median_income_weighted_crimes, 
  SAFE_DIVIDE(
    SAFE_SUBTRACT(
      acs.median_income, 
      SAFE_MULTIPLY(
        acs.median_income, 
        1 - SAFE_DIVIDE(x.total_crimes, acs.total_pop)
      )
    ), 
    acs.median_income
  ) as median_income_weighted_delta 
from 
  `bigquery-public-data.geo_census_tracts.census_tracts_tennessee` ct 
  left join `bigquery-public-data.geo_us_boundaries.counties` c on (
    ct.state_fips_code || ct.county_fips_code
  ) = c.geo_id 
  left join `bigquery-public-data.census_bureau_acs.censustract_2018_5yr` acs on ct.geo_id = acs.geo_id 
  left join total_crimes_geo on ct.geo_id = total_crimes_geo.geo_id 
where 
  c.county_name = 'Davidson' 
order by 
  median_income_weighted_delta desc