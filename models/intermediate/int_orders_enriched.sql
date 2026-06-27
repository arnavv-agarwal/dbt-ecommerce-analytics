with orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

order_totals as (
    select
        order_id,
        sum(line_total_inr) as order_total_inr,
        sum(line_total_usd) as order_total_usd,
        sum(quantity) as total_items
    from order_items
    group by order_id
),

final as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status,
        o.status_raw,
        o.shipping_city,
        o.payment_method,
        o.discount_pct,
        o.is_completed,
        ot.order_total_inr,
        ot.order_total_usd,
        ot.total_items,
        round((ot.order_total_inr * (1 - o.discount_pct / 100.0))::numeric, 2) as discounted_total_inr
    from orders o
    left join order_totals ot on o.order_id = ot.order_id
)

select * from final
