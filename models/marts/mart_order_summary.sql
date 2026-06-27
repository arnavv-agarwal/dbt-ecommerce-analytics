with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

final as (
    select
        order_id,
        customer_id,
        order_date,
        status,
        status_raw,
        shipping_city,
        payment_method,
        discount_pct,
        total_items,
        order_total_inr,
        {{ inr_to_usd('order_total_inr') }} as order_total_usd,
        discounted_total_inr,
        {{ inr_to_usd('discounted_total_inr') }} as discounted_total_usd,
        round((order_total_inr - discounted_total_inr)::numeric, 2) as discount_amount_inr
    from orders
)

select * from final
