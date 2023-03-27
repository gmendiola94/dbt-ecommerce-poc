{{
  config(
    materialized = 'incremental',
    unique_key = 'id',
    incremental_strategy='merge'
    )
}}

-- incremental refresh set to 3 days 

with orders as (
    select * from {{ ref('stg_orders')  }} 
    where
        1 = 1
        {% if is_incremental() %}
            and created_at
            >= dateadd(day, -2, (select max(created_at) from {{ this }}))
        {% endif %}
),

 order_items as (
    select
        order_id,
        product_id,
        sum(sale_price) / count(*) as unit_retail_price,
        sum(sale_price) as total_amount,
        count(*) as qty_items,
        sum(case when returned_at is not null then 1 end) as qty_items_returned
    from {{ ref('stg_order_items') }}
    group by 
        order_id,
        product_id
),

product_cost as (
select 
       id,
       distribution_center_id,
       cost 
from {{ ref('stg_products') }}
group by 
        id,
        distribution_center_id,
        cost
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
        round(unit_retail_price,2) as unit_retail_price,
        round(total_amount,2) as total_amount,
        round(unit_retail_price - product_cost.cost,2) as product_profit,
        round((unit_retail_price - product_cost.cost)/unit_retail_price,2) as product_profit_margin,
        qty_items,
        qty_items_returned,
        datediff(day,SHIPPED_AT,DELIVERED_AT) as shipping_days,
        datediff(day,CREATED_AT,SHIPPED_AT) as lead_time_days,
        sysdate() as dbt_run_timestamp
    from orders
    left join order_items on orders.order_id = order_items.order_id
    left join product_cost on order_items.product_id = product_cost.id
)

select *
from fact_orders
