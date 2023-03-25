{{
  config(
    materialized = 'table',
    )
}}

with products as (
    select *
    from {{ ref('stg_products') }}

)

select
    id,
    sku,
    brand,
    name,
    category,
    department,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_products_hashid
from products
