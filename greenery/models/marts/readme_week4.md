Solid 77% of sessions go onto adding some sort of product to the cart, and 62% of sessions end in an order! That's a pretty solid funnel.

```
with event_counts as (
  select
    count(*)
    ,sum(case when nb_page_view > 0 then 1 else 0 end) as sessions_with_pageview
    ,sum(case when nb_add_to_cart > 0 then 1 else 0 end) as sessions_with_cart
    ,sum(case when nb_checkout > 0 then 1 else 0 end) as sessions_with_checkout
  from dbt_matilda_h.fct_sessions
)
,
funnel as (
  select  
      round((sessions_with_checkout::numeric / sessions_with_cart::numeric),2) as cart_to_checkout
      ,round((sessions_with_checkout::numeric / sessions_with_pageview::numeric),2) as page_to_cart
    from event_counts
)

select * from funnel
```

I was also able to set up funnels for the products themselves in the fct_product_events table, alongside a variable showing how many times a product was abandoned. The poor peace lily, boston fern and angel wings begonia didn't stand a chance :(. Two of those products are quite expensive, maybe they are the first to go once the user has to pick out favourites?

