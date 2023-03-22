{{
  config(
    materialized = 'table',
    )
}}

select
    id,
    name as location,
    latitude,
    longitude,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_distribution_centers_hashid
from {{ source('airbyte_schema', 'distribution_centers') }}
