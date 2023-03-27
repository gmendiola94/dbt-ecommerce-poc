{{
  config(
    materialized = 'incremental',
    unique_key = 'id',
    incremental_strategy='merge'
    )
}}

-- incremental refresh set to 3 days 
with inventory as (
    select * from {{ ref('stg_inventory_items') }}
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
    product_distribution_center_id,
    product_id,
    sold_at,
    created_at,
    product_retail_price,
    cost,
    round(product_retail_price - cost, 2) as profit,
    round(
        (product_retail_price - cost) / product_retail_price, 2
    ) as product_profit_margin,
    datediff(day, created_at, sold_at) as days_to_sale,
    sysdate() as dbt_run_timestamp
from inventory
