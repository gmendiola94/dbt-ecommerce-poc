{{
  config(
    materialized = 'table',
    )
}}

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
from {{ source('airbyte_schema', 'inventory_items') }}
