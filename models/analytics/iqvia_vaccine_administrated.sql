select
    DATE,
    ROUND(MARKET::int*100/70000000) as MARKET
from {{ source('mtx_datapipeline_covid_iqvia_symphony_veeva', 'iqvia_covid_unadjusted_retail')}}
WHERE SAMPLE_TYPE = 'cumulative'