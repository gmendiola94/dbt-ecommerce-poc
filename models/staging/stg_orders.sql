{{
  config(
    materialized = 'ephemeral',
    )
}}

select

    order_id,
    shipped_at,
    gender,
    num_of_item,
    user_id,
    returned_at,
    created_at,
    delivered_at,
    status,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_orders_hashid
from {{ source('airbyte_schema', 'orders') }}
