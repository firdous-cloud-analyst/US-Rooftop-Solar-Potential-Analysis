☀️ US Rooftop Solar Potential Analysis

Identifying untapped rooftop solar opportunity across US states using BigQuery SQL and Power BI.
📌 Project Summary

Solar companies and policymakers need to know where to focus investment and outreach — not just where sunlight is strongest, but where high solar potential is going unrealized. This project analyzes Google's Project Sunroof public dataset to answer that question, and packages the findings into an interactive Power BI dashboard.

Business question:

As solar potential varies across the US, which states have high sunlight potential but low actual adoption — representing the greatest untapped opportunity for future investment?
🗂️ Dataset

Source: bigquery-public-data.sunroof_solar.solar_potential_by_postal_code (Google Project Sunroof, via BigQuery Public Datasets)
Grain: ZIP-code level, aggregated to state level for analysis
Key fields used: yearly_sunlight_kwh_kw_threshold_avg, count_qualified, existing_installs_count, carbon_offset_metric_tons, state_name.

🧹 Data Cleaning

Raw data quality checks surfaced a real issue before any analysis could begin:


state_name contained 69 distinct values, not the expected 51 (50 states + DC).
Investigation revealed the extras were Puerto Rico municipalities (San Juan, Ponce, Bayamón, etc.) and Baja California, Mexico — incorrectly populating the state field.
Built a cleaned BigQuery view (solar_clean) filtering to the valid 50 states + DC, used as the single source of truth for every downstream query.


This is documented because it materially affects any state-level rollup — using the raw table as-is would silently inflate the state count and misattribute records.
🛠️ Methodology (SQL)

All analysis was done in BigQuery SQL before ever touching Power BI — the dashboard visualizes pre-validated results, not raw data.

Technique                         Where it's used
CTEs (multi-step chaining)        Combining sunlight and adoption metrics per stateWindow functions 
(RANK() OVER)                     Ranking states independently by sunlight potential and by adoption rateCorrelated 
subqueries                        Filtering states above the national average sunlight potential
Conditional aggregation           Estimating "realized" carbon offset from installed-building proportion
Core metric — Opportunity Score:
opportunity_score = sunlight_rank + adoption_rank
States are ranked separately on sunlight potential (descending) and adoption rate (ascending — lowest adoption ranked first). Summing the two ranks surfaces states that are simultaneously high potential and low adoption — the actual investment opportunity, rather than just "low adoption" states that also happen to have poor sunlight.

An earlier version of this metric used an absolute (potential − realized) / potential gap percentage, but that metric saturated near 99% for almost every state (adoption is low nationwide), making it useless for ranking. The relative-rank approach above was adopted instead — a data-quality finding worth calling out in its own right
🔑 Key Findings

Wyoming, South Dakota, and Oklahoma show the strongest combination of high sunlight potential and low solar adoption — the top "untapped opportunity" states.
Hawaii has by far the highest adoption rate (~12.4%) despite only moderate sunlight ranking — suggesting adoption is driven by factors beyond sunlight alone (e.g., electricity cost, incentives).
Nationally, realized carbon offset is a small fraction of technical potential — the gap is largest in low-population, high-sunlight states.
📊 Dashboard

Built in Power BI, connected live to BigQuery, across 4 pages plus a custom drill-through tooltip:

PagePurposeOverviewNational snapshot — sunlight potential map, adoption leaders, key KPIsAdoptionAdoption rate landscape — top/bottom 10 states, highest/lowest/medianOpportunityCore insight — sunlight vs. adoption scatter plot, ranked opportunity table, recommendationCarbon Impact
🧰 Tech Stack
Google BigQuery — data storage, cleaning, and SQL analysis
SQL — CTEs, window functions, subqueries, view management
Power BI — dashboard, DAX measures, custom tooltips, navigation









