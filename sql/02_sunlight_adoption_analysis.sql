

CREATE OR REPLACE VIEW `power-generation-analysis.power_generation_us.v_sunlight_adoption` 
AS
with sunlight_data as 
(
  select  
      state_name,
      round(avg(yearly_sunlight_kwh_kw_threshold_avg),2) as avg_yearly_sunlight
  from `power-generation-analysis.power_generation_us.solar_clean`
group by 1
),
adoption_rate as 
(SELECT 
      state_name,
      sum(existing_installs_count)Total_instoletion,
      SUM(count_qualified)Total_Qualifaid_instoletion
FROM `power-generation-analysis.power_generation_us.solar_clean`
GROUP BY 1)
select
    sd.state_name,
    sd.avg_yearly_sunlight,
    ar.Total_instoletion,
    ar.Total_Qualifaid_instoletion,
    SAFE_DIVIDE(ar.Total_instoletion,ar.Total_Qualifaid_instoletion) * 100
    AS adop_rate
 from sunlight_data as sd
 join adoption_rate as ar
  on sd.state_name=ar.state_name 
  where sd.avg_yearly_sunlight > (select avg(avg_yearly_sunlight) from sunlight_data )
order by 5 asc;



