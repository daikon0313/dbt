{{ config(materialized="view") }}

with
    latest_fetch as (
        select max(fetched_at) as fetched_at from {{ ref("flatten_source") }}
    )

select *
from {{ ref("flatten_source") }}
where fetched_at = (select max(fetched_at) from latest_fetch)
order by end_time desc
