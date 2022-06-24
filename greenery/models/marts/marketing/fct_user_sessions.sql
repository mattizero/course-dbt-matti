
{{
  config(
    materialized='table'
  )
}}

with aggregated_and_pivoted_to_user as (
    SELECT

        u.user_guid
        ,u.first_name
        ,u.last_name

        ,count(distinct s.session_guid) as nb_sessions
        ,max(s.session_start) as last_session
        
        ,avg(s.session_length) as avg_session_length
        ,coalesce(round(avg(s.nb_events)),0) as avg_nb_events
        ,coalesce(round(avg(s.nb_products_viewed)),0) as avg_products_viewed
        ,coalesce(round((sum(case when
            s.order_placed is FALSE then 0
            when s.order_placed is TRUE then 1
            end)::numeric
            / 
            count( distinct s.session_guid))::numeric),0)
        as session_to_order_ratio
        -- Make into separate table? Does this even work?

    from {{ref ('dim_users')}} u 
    left join {{ref ('fct_sessions')}} s on s.user_guid = u.user_guid
    group by 1,2,3
)

select * from aggregated_and_pivoted_to_user