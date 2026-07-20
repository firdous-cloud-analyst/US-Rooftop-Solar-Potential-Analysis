 
CREATE OR REPLACE VIEW `power-generation-analysis.power_generation_us.v_opportunity_score`
 as
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
GROUP BY 1),
adoptio_percentage as 
(select
    sd.state_name,
    sd.avg_yearly_sunlight,
    ar.Total_instoletion,
    ar.Total_Qualifaid_instoletion,
    SAFE_DIVIDE(ar.Total_instoletion,ar.Total_Qualifaid_instoletion) * 100
    AS adop_rate
 from sunlight_data as sd
 join adoption_rate as ar
  on sd.state_name=ar.state_name),
ranking as
(select  
    state_name,
    avg_yearly_sunlight,
 rank()over(order by avg_yearly_sunlight desc)sunlight_rank,
    rank()over(order by adop_rate asc )adoption_rank
from adoptio_percentage)
select 
    state_name,
    sunlight_rank,
    adoption_rank,
    (sunlight_rank + adoption_rank)opportunity_score
from ranking
order by opportunity_score asc;
