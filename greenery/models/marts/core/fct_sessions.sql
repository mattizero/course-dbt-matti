{{
  config(
    materialized='table'
  )
}}

with aggregated_sessions as (
  select 
      es.session_guid
      ,es.user_guid
      ,u.first_name
      ,u.last_name
      ,CASE 
        when es.nb_session_orders > 0
          then TRUE
        else FALSE
      end as order_placed
      ,es.nb_events
      ,es.nb_products_viewed
      ,es.session_start
      ,date_trunc('day', es.session_start) as session_day
      ,age(es.session_end,es.session_start) as session_length

from {{ ref('int_events_pivoted_to_sessions')}} es
left join {{ ref('dim_users')}} u on u.user_guid = es.user_guid
group by 1,2,3,4,5,6,7,8,9,10
)

select * from aggregated_sessions