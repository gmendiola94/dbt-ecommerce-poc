{{
  config(
    materialized = 'incremental',
    unique_key = '_airbyte_ab_id',
    incremental_strategy='merge'
    )
}}

-- incremental refresh set to 3 days 
with inventory_items as (
    select * from {{ source('airbyte_schema', 'inventory_items') }}
    where
        1 = 1
        {% if is_incremental() %}
            and created_at
            >= dateadd(day, -2, (select max(created_at) from {{ this }}))
        {% endif %}
)
select
    id,
    product_sku,
    product_department,
    cost,
    product_id,
    sold_at,
    created_at,
    product_brand,
    product_distribution_center_id,
    product_name,
    product_retail_price,
    product_category,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_inventory_items_hashid
from inventory_items
