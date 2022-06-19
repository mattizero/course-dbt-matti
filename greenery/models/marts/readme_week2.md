We have almost 80% returning customers, which is great news!

```
with cte_returning as (
  select 
    user_guid
    ,count(distinct order_guid) as nb_orders
  from dbt_matilda_h.stg_greenery__orders
  group by 1
  having count(distinct order_guid) > 1
  )
,
cte_counts as (
    select 
        count(distinct stg_greenery__orders.user_guid) as all_customers
        ,count(distinct cte_returning.user_guid) as returning_customers
    from dbt_matilda_h.stg_greenery__orders
    left join cte_returning on stg_greenery__orders.user_guid=cte_returning.user_guid
)

select (returning_customers::numeric / all_customers::numeric) * 100 as pct from cte_counts
```

***Some ideas on what makes customers return:***
* Are our deliveries fast and do we offer next-day delivery? How often do customers choose this option? How often are deliveries late, and are we promising them a delivery date we cannot keep?

* Do our promotions work? I wanted to add a promo table to this week's model, but found myself running out of steam and energy, but I am keen to add some in future weeks.

* In my model build, I was curious about the products greenery offers. Are we spending money on items that aren't actually very popular? How often are items viewed and how many of those views actually translate to an order? Another big issue would obviously be the wuality of the product, and adding review scores to our events table might be a good way to track this.

* Final thought that I did not have time to have a look at: Would location play a role? We are an INDOOR plant shop after all, are northernly locations longing for more plants in the winter? And are certain states suffering from long delivery times, resulting in sad, thirsty and even dead plants?

***Why did I add the models I did?***

As said above, I'm mostly curious about how ours users interact with our two products - our website (a product in itself) and our plants. If I had infinite time and energy, I would add more tables surrounding promos, location data etc.. But as things are, I decided to focus on site interaction and product popularity.


***Tests***
Unfortunately a lot of these tests are set in my fct/dim/int stage. I don't consider this to be good practice, and had this been a real dataset I would move several of these! As this is only a play dataset, I shall leave them as is, and can only ask for my reviewers' understanding.


**My test failures**
Initially put a test in fct_sessions suggesting user_guid should be unique. Oops, it shouldn't, because obviously a user might have more than one session! Removed that, kept the null check though.

My unique test for order_guid in fct_orders failed. I definitely don't want that and had to investigate. Turns out I'm bringing in order_items, which double joins to the table. Will either have to do a sum, or figure something else out...

**My test triumphs**
I wanted to make a regex test, something that checks that a field ONLY has alphabetical or numerical characters in it (something like a name should probably only have these characters). Alphabetical_check has therefore been implemented on first names. Might be worth doing a similar thing for email...?

I had initially intented to put my very simple regex check on last names, but upon running it remembered that last names have lots of special characters. Will have to build a more robust check in the future! (Or perhaps just an anti-numeric test...?)


**Stakeholders**
In order to assure the stakeholders that our data is secure and tested regularly, I'd be tempted to set up some sort of automatic daily nightly run that will notify the data team should something go awry. Keep a list of users of the table and make sure that any tables that build upon these ones are registred somewhere. If large data issue occurs, notify users of table!