

{{
  config(
    materialized='table'
  )
}}

with fct_orders as (
    select 

        o.order_guid
        ,u.user_guid

        ,u.first_name
        ,u.last_name
        ,a.delivery_address
        ,a.state
        ,a.country

        ,p.promo_id
        ,p.discount_type

        ,o.shipping_service
        ,o.status as order_status

        ,o.order_cost_usd
        ,o.shipping_cost_usd
        ,o.order_total_usd
        
        ,CASE 
            when estimated_delivery_at_utc > delivered_at_utc
                then 'early'
            when estimated_delivery_at_utc = delivered_at_utc
                then 'on time'
            when estimated_delivery_at_utc < delivered_at_utc
                then 'late'
            end as delivery_status
            
        ,age(o.delivered_at_utc,o.created_at_utc) as delivery_time

        ,o.created_at_utc
        ,date_trunc('day', o.created_at_utc) as order_placed_day
        ,date_trunc('day', o.delivered_at_utc) as delivery_day

    from {{ref ('stg_greenery__orders')}} o
    left join {{ref ('stg_greenery__users')}} u                 on o.user_guid = u.user_guid
    left join {{ref ('stg_greenery__addresses')}} a             on u.address_guid = a.address_guid
    left join {{ref ('stg_greenery__promos')}} p                on o.promo_id = p.promo_id
)

select * from fct_orders