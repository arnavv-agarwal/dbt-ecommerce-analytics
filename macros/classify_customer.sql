{% macro classify_customer(lifetime_value) %}
    case
        when {{ lifetime_value }} >= 500000 then 'Platinum'
        when {{ lifetime_value }} >= 200000 then 'Gold'
        when {{ lifetime_value }} >= 50000  then 'Silver'
        else 'Bronze'
    end
{% endmacro %}
