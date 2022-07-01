{{
  config(
    materialized='ephemeral'
  )
}}
{%- set event_types = dbt_utils.get_column_values(
    table=ref('stg_greenery__events'),
    column='event_type'
) -%}


with pivot_and_aggregate_as_product_grain as (
    select
        p.product_guid
        ,p.product_name
      ,{%- for event_type in event_types %}
        sum(case when event_type='{{event_type}}' then 1
        else 0
        end) as nb_{{event_type}}
        {%- if not loop.last %},{% endif -%}
      {% endfor %}
    from {{ ref('stg_greenery__products')}} p
    left join {{ref('stg_greenery__events')}} e on e.product_guid=p.product_guid
    group by 1,2
)

select * from pivot_and_aggregate_as_product_grain
