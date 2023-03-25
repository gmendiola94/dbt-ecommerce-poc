{{
  config(
    materialized = 'table',
    )
}}

with customers as (
    select *
    from {{ ref('stg_users') }}

)

select
    id,
    created_at,
    first_name,
    last_name,
    gender,
    city,
    street_address,
    state,
    country,
    postal_code,
    age,
    email,
    longitude,
    latitude,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_users_hashid
from customers
