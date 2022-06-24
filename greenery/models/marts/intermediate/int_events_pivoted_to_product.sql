{{
  config(
    materialized='ephemeral'
  )
}}


with pivot_and_aggregate_as_product_grain as (
    select
        p.product_guid
        ,p.product_name
        ,count(p.product_guid) as nb_times_viewed
        ,sum(case when e.event_type='add_to_cart' then 1
        else 0
        end) as nb_add_to_cart
    from {{ ref('stg_greenery__products')}} p
    left join {{ref('stg_greenery__events')}} e on e.product_guid=p.product_guid
    group by 1,2
)

select * from pivot_and_aggregate_as_product_grain
