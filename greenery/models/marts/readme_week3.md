What is our overall conversion rate?
Our overall conversion rate is 62%, which sounds pretty good to me!

```
select 
  (sum(case when order_placed = True then 1
  else 0
  end)::numeric 
  / 
  count(distinct session_guid)::numeric) as conversion_rate
  from dbt_matilda_h.fct_sessions
```

What is our conversion rate by product?
Luckily I made a column for this last week!

```
select order_rate from dbt_matilda_h.fct_product_events
```

Our item with the highest conversion rate is the String of Pearls...

```
select 
    product_name
    ,order_rate 
    from dbt_matilda_h.fct_product_events 
where order_rate=(select max(order_rate) 
                  from dbt_matilda_h.fct_product_events)
```

and our lowest conversion rate is the Pothos (undeservedly so, the golden pothos is a lovely  and hardy plant)
```
select 
    product_name
    ,order_rate 
    from dbt_matilda_h.fct_product_events 
where order_rate=(select min(order_rate) 
                  from dbt_matilda_h.fct_product_events)
```

