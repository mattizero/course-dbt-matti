  
{{
  config(
    materialized='table'
  )
}}

with aggregated_and_pivoted_to_user as (
  select 
    u.user_guid

    ,count(o.order_guid) as nb_orders
    ,min(o.created_at_utc) as first_order
    ,max(o.created_at_utc) as last_order
    ,sum( 
        case 
          when delivery_status = 'on time' then 1
          else 0 
        end) as nb_orders_on_time
    ,sum(
      case 
        when delivery_status = 'late' then 1
        else 0 
      end) as nb_late_orders
    ,count(o.promo_id) as nb_promos_used
    ,coalesce(round(avg(o.order_total_usd)),0) as avg_revenue
  from {{ ref('dim_users')}} u
  left join {{ ref('fct_orders')}} o on u.user_guid = o.user_guid
  group by 1
)

select * from aggregated_and_pivoted_to_user