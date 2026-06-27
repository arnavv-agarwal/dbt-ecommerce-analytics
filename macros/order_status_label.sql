{% macro order_status_label(status_col) %}
    case {{ status_col }}
        when 'completed'  then 'Completed'
        when 'returned'   then 'Returned'
        when 'cancelled'  then 'Cancelled'
        else 'Unknown'
    end
{% endmacro %}
