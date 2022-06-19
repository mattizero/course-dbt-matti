{% test alphabetical_check(model, column_name) %}


   select *
   from {{ model }}
   where {{ column_name }} ~* '[^a-z+$]'


{% endtest %}