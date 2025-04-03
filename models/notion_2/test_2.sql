{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='date'
) }}

with source as (
    select *
    from {{ ref('test') }}
)

select *
from source