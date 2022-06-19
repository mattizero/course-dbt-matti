
{{
  config(
    materialized='table'
  )
}}

with dim_users as (
  select 

      u.user_guid
      ,u.first_name
      ,u.last_name

      ,a.delivery_address
      ,a.zipcode
      ,a.state
      ,a.country

      ,u.email
      ,u.phone_number

      ,age(date_trunc('day', current_date),date_trunc('day',u.created_at_utc)) as account_age_days
      ,date_trunc('day',u.created_at_utc) as joining_date

from {{ ref('stg_greenery__users')}} u 
left join {{ ref('stg_greenery__addresses')}} a on u.address_guid = a.address_guid
)

select * from dim_users