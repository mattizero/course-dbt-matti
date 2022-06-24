{% macro delivery_status(est_date, real_date) %}
    (case 
        when {{ est_date }} < {{real_date}} and {{real_date}} is not null THEN 'late'
        when {{ est_date }} = {{real_date}} and {{real_date}} is not null then 'on_time'
        when {{ est_date }} > {{real_date}} and {{real_date}} is not null then 'early'
        else null
    end)
{% endmacro %}