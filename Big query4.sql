


CREATE OR REPLACE VIEW `power-generation-analysis.power_generation_us.v_carbon_gap` 
as
with realize_offset as
(select 
    state_name,
    sum(existing_installs_count) as Total_instoletion,
    SUM(count_qualified) as Total_Qualifaid_instoletion,
    sum(carbon_offset_metric_tons)as corbon_offset_tons,
    safe_divide(sum(existing_installs_count), sum(count_qualified)) as installed_fraction,
from `power-generation-analysis.power_generation_us.solar_clean`
group by 1),
potential_offset as 
(select
    state_name,
    sum(carbon_offset_metric_tons)as carbon_offset_tons
from `power-generation-analysis.power_generation_us.solar_clean`
group by 1),
combain as 
(select 
   ro.state_name,
    ro.Total_instoletion,
    ro.Total_Qualifaid_instoletion,
    ro.corbon_offset_tons as potential_offset,
    safe_multiply( po.carbon_offset_tons,ro.installed_fraction) as realized_offset   
from realize_offset as ro
join potential_offset as po
   on ro.state_name = po.state_name 
order by realized_offset desc)
select
    state_name,
    potential_offset,
    realized_offset,
    safe_divide((potential_offset - realized_offset), potential_offset) * 100 as gap_pct
from combain
order by gap_pct desc;
