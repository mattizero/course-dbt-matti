{{
  config(
    materialized='table'
  )
}}

with orders_and_products_joined as (
    select
        o.order_guid
        ,u.user_guid
        ,p.product_guid
        ,p.product_name
        ,p.price_usd
        ,oi.product_qty
        ,o.created_at_utc
    from {{ ref('fct_orders')}} o
    left join {{ ref('stg_greenery__order_items')}} oi      on oi.order_guid = o.order_guid
    left join {{ ref('dim_products')}} p                    on oi.product_guid=p.product_guid
    left join {{ ref('dim_users')}} u                       on o.user_guid=u.user_guid
    group by 1,2,3,4,5,6,7
    order by 1
)
,
aggregated_and_pivoted_to_product as (
  select 
      product_guid
      ,product_name
      ,sum(product_qty) AS units_sold
      ,round(sum(price_usd * product_qty)) as expected_revenue
      ,count(distinct order_guid) as times_ordered
      ,count(distinct user_guid) as nb_users_ordered
      ,max(created_at_utc) as last_ordered
      from orders_and_products_joined
  group by 1,2
  order by 2
)

select * from aggregated_and_pivoted_to_product