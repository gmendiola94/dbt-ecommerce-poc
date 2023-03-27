{{
  config(
    materialized = 'incremental',
    unique_key = '_airbyte_ab_id',
    incremental_strategy='merge'
    )
}}

-- incremental refresh set to 3 days 
with orders as (
    select * from {{ source('airbyte_schema', 'orders') }} 
    where
        1 = 1
        {% if is_incremental() %}
            and created_at
            >= dateadd(day, -2, (select max(created_at) from {{ this }}))
        {% endif %}
)

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
from orders
