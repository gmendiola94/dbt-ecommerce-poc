{{
  config(
    materialized = 'ephemeral',
    )
}}

select
    id,
    cost,
    distribution_center_id,
    name,
    sku,
    category,
    department,
    brand,
    retail_price,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_products_hashid
from {{ source('airbyte_schema', 'products') }}
