{{
  config(
    materialized = 'table',
    )
}}

with inventory as (
    select *
    from {{ ref('stg_inventory_items') }}

)

select
    id,
    product_sku,
    product_distribution_center_id,
    product_id,
    sold_at,
    created_at,
    product_retail_price,
    cost,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_inventory_items_hashid
from inventory
