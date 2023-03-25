{{
  config(
    materialized = 'table',
    )
}}

with order_items as (
    select
        order_id,
        product_id,
        sum(sale_price) / count(*) as unit_retail_price,
        sum(sale_price) as total_amount,
        count(*) as qty_items,
        sum(case when returned_at is not null then 1 end) as qty_items_returned
    from {{ ref('stg_order_items') }}
    group by order_id,
             product_id
),

orders as (
    select *
    from {{ ref('stg_orders') }}
),

product_cost as (
select id,
       distribution_center_id,
       cost 
from {{ ref('stg_products') }}
group by id,distribution_center_id,cost

),

fact_orders as (
    select
        {{ dbt_utils.generate_surrogate_key(['orders.order_id', 'user_id', 'product_id']) }} as id,
        orders.order_id,
        user_id,
        product_id,
        distribution_center_id,
        returned_at,
        created_at,
        shipped_at,
        delivered_at,
        status,
        round(product_cost.cost,2) as unit_cost,
        round(qty_items*product_cost.cost,2) as total_sale_cost,
        round(unit_retail_price,2) AS unit_retail_price,
        round(total_amount,2) as total_amount,
        qty_items,
        qty_items_returned
    from orders
    left join order_items on orders.order_id = order_items.order_id
    left join product_cost on order_items.product_id = product_cost.id
)

select *
from fact_orders
