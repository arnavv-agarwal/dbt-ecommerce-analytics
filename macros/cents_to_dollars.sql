{% macro inr_to_usd(amount_inr, exchange_rate=83.5) %}
    round(({{ amount_inr }} / {{ exchange_rate }})::numeric, 2)
{% endmacro %}
