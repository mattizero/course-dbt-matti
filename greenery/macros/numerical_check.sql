{% test numerical_check(model, column_name) %}


   select *
   from {{ model }}
   where {{ column_name }} ~ '[^0-9+$]'


{% endtest %}