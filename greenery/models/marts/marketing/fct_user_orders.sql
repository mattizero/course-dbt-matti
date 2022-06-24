  
{{
  config(
    materialized='table'
  )
}}

{%- set shipping_services = dbt_utils.get_column_values(
    table=ref('fct_orders'),
    column='shipping_service'
) -%}
{%- set delivery_statuses = dbt_utils.get_column_values(
    table=ref('fct_orders'),
    column='delivery_status'
) -%}


with aggregated_and_pivoted_to_user as (
  select 
    u.user_guid

    ,count(o.order_guid) as nb_orders
    ,min(o.created_at_utc) as first_order
    ,max(o.created_at_utc) as last_order

    ,{%- for status in delivery_statuses %}
      sum(case when delivery_status='{{status}}' then 1
      else 0
      end) as nb_delivery_{{status}}
      {%- if not loop.last %},{% endif -%}
    {% endfor %}

    ,{%- for company in shipping_services %}
      sum(case when shipping_service='{{company}}' then 1
      else 0
      end) as nb_delivered_by_{{company}}
      {%- if not loop.last %},{% endif -%}
    {% endfor %}

    ,count(o.promo_id) as nb_promos_used
    ,coalesce(round(avg(o.order_total_usd)),0) as avg_revenue
  from {{ ref('dim_users')}} u
  left join {{ ref('fct_orders')}} o on u.user_guid = o.user_guid
  group by 1
)

select * from aggregated_and_pivoted_to_user