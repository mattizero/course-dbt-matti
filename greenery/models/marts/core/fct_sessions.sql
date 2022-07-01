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
      ,es.nb_page_view
      ,es.nb_add_to_cart
      ,es.nb_checkout
      ,es.nb_products_viewed
      ,es.session_start
      ,date_trunc('day', es.session_start) as session_day
      ,age(es.session_end,es.session_start) as session_length

from {{ ref('int_events_pivoted_to_sessions')}} es
left join {{ ref('dim_users')}} u on u.user_guid = es.user_guid
)

select * from aggregated_sessions