SELECT 
      *
 FROM `bigquery-public-data.sunroof_solar.solar_potential_by_postal_code` LIMIT 10;


SELECT
   count(distinct state_name) as Total_state_name,
   count(region_name)as Total_number_of_region  
FROM `bigquery-public-data.sunroof_solar.solar_potential_by_postal_code`;


select
   round(avg(yearly_sunlight_kwh_kw_threshold_avg),2) as avg_yearly_sunlight_kwh_kw_threshold_avg,state_name from `bigquery-public-data.sunroof_solar.solar_potential_by_postal_code`
group by 2 order by 1 desc;


select 
    state_name 
from`bigquery-public-data.sunroof_solar.solar_potential_by_postal_code`
where state_name not in (
"Alabama",
"Alaska",
"Arizona",
"Arkansas",
"California",
"Colorado",
"Connecticut",
"Delaware",
"Florida",
"Georgia",
"Hawaii",
"Idaho",
"Illinois",
"Indiana",
"Iowa",
"Kansas",
"Kentucky",
"Louisiana",
"Maine",
"Maryland",
"Massachusetts",
"Michigan",
"Minnesota",
"Mississippi",
"Missouri",
"Montana",
"Nebraska",
"Nevada",
"New Hampshire",
"New Jersey",
"New Mexico",
"New York",
"North Carolina",
"North Dakota",
"Ohio",
"Oklahoma",
"Oregon",
"Pennsylvania",
"Rhode Island",
"South Carolina",
"South Dakota",
"Tennessee",
"Texas",
"Utah",
"Vermont",
"Virginia",
"Washington",
"West Virginia",
"Wisconsin",
"Wyoming"
);


CREATE OR REPLACE VIEW 
`power-generation-analysis.power_generation_us.solar_clean`
AS
SELECT * FROM `bigquery-public-data.sunroof_solar.solar_potential_by_postal_code`
WHERE state_name IN  (
  'Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut',
  'Delaware','District of Columbia','Florida','Georgia','Hawaii','Idaho','Illinois',
  'Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Maryland','Massachusetts',
  'Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada',
  'New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota',
  'Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina',
  'South Dakota','Tennessee','Texas','Utah','Vermont','Virginia','Washington',
  'West Virginia','Wisconsin','Wyoming'
);


SELECT 
  count(distinct state_name) as Total_state_name,
count(*)as Total_number_of_row 
FROM `power-generation-analysis.power_generation_us.solar_clean`;

select
     round(avg(yearly_sunlight_kwh_kw_threshold_avg),2) as avg_yearly_sunlight_kwh_kw_threshold_avg,
     state_name 
from `power-generation-analysis.power_generation_us.solar_clean`
GROUP BY 2
ORDER BY 1 DESC;

with adoption_rate as 
(SELECT 
      state_name,
      sum(existing_installs_count)Total_instoletion,
      SUM(count_qualified)Total_Qualifaid_instoletion
FROM `power-generation-analysis.power_generation_us.solar_clean`
GROUP BY 1
ORDER BY 2 desc)
select 
      state_name,
      Total_instoletion,
      Total_Qualifaid_instoletion,
     (Total_instoletion/Total_Qualifaid_instoletion)*100 as adop_rate

from adoption_rate;




    

