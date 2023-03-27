{{
  config(
    materialized = 'incremental',
    unique_key = '_airbyte_ab_id',
    incremental_strategy='merge'
    )
}}

-- incremental refresh set to 3 days 
with order_items as (
    select * from {{ source('airbyte_schema', 'order_items') }}
    where
        1 = 1
        {% if is_incremental() %}
            and created_at
            >= dateadd(day, -2, (select max(created_at) from {{ this }}))
        {% endif %}
)
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
from order_items
