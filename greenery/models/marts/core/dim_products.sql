{{
  config(
    materialized='table'
  )
}}

with dim_products as (
  select 
      
      product_guid
      ,product_name
      ,price_usd
      ,inventory_qty

  from {{ref('stg_greenery__products')}}
)

select * from dim_products