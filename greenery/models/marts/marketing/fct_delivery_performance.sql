{{
  config(
    materialized='table'
  )
}}

{%- set delivery_statuses = dbt_utils.get_column_values(
    table=ref('fct_orders'),
    column='delivery_status',
    where='delivery_status is not null'
) -%}

with delivery_performance as (

    select 
        shipping_service
        ,{%- for status in delivery_statuses %}
        sum(case when delivery_status='{{status}}' then 1
        else 0
        end) as nb_delivery_{{status}}
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
    from {{ ref('fct_orders')}}
    where shipping_service is not null
    group by 1
)

select * from delivery_performance