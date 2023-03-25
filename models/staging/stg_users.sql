{{
  config(
    materialized = 'ephemeral',
    )
}}

select
    id,
    country,
    street_address,
    gender,
    city,
    latitude,
    last_name,
    created_at,
    traffic_source,
    state,
    postal_code,
    first_name,
    age,
    email,
    longitude,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_users_hashid
from {{ source('airbyte_schema', 'users') }}
