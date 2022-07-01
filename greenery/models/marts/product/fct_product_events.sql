
{{
  config(
    materialized='table'
  )
}}

with aggregated_and_pivoted_to_product as (
  select
      ip.product_guid
      ,ip.product_name
      ,ip.nb_page_view
      ,ip.nb_add_to_cart
      ,po.times_ordered
      ,round((ip.nb_add_to_cart::numeric / ip.nb_page_view::numeric), 2) as view_to_cart_rate
      ,round((po.times_ordered::numeric / ip.nb_page_view::numeric) ,2) as order_rate
      ,(ip.nb_add_to_cart - po.times_ordered ) as times_abandoned
  from {{ ref('int_events_pivoted_to_product')}} ip
  left join {{ ref('fct_product_orders')}} po on po.product_guid = ip.product_guid
)

select * from aggregated_and_pivoted_to_product