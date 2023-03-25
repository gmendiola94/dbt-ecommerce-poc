{{
  config(
    materialized = 'table',
    )
}}

with centers as (
    select *
    from {{ ref('stg_distribution_centers') }}
)

select
    id,
    name as center_location,
    latitude,
    longitude,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_distribution_centers_hashid
from centers
