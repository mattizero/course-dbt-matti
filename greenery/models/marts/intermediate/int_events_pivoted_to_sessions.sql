
{{
  config(
    materialized='ephemeral'
  )
}}

{%- set event_types = dbt_utils.get_column_values(
    table=ref('stg_greenery__events'),
    column='event_type'
) -%}

with pivot_and_aggregate_as_session_grain as (
  select
      session_guid
      ,user_guid
      ,min(created_at_utc) as session_start
      ,max(created_at_utc) as session_end
      ,count(event_guid) as nb_events
      ,{%- for event_type in event_types %}
        sum(case when event_type='{{event_type}}' then 1
        else 0
        end) as nb_{{event_type}}
        {%- if not loop.last %},{% endif -%}
      {% endfor %}
      ,count(distinct order_guid) as nb_session_orders
      ,count(distinct product_guid) as nb_products_viewed
  from {{ ref('stg_greenery__events')}}
  group by 1,2
)

select * from pivot_and_aggregate_as_session_grain