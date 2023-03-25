{{
  config(
    materialized = 'ephemeral',
    )
}}

select
    id,
    shipped_at,
    user_id,
    returned_at,
    inventory_item_id,
    product_id,
    created_at,
    order_id,
    sale_price,
    delivered_at,
    status,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_order_items_hashid
from {{ source('airbyte_schema', 'order_items') }}
