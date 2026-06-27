with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('int_orders_enriched') }}
),

customer_metrics as (
    select
        customer_id,
        count(order_id) as total_orders,
        count(case when is_completed then 1 end) as completed_orders,
        count(case when status_raw = 'returned' then 1 end) as returned_orders,
        count(case when status_raw = 'cancelled' then 1 end) as cancelled_orders,
        sum(case when is_completed then discounted_total_inr else 0 end) as lifetime_value_inr,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date
    from orders
    group by customer_id
),

final as (
    select
        c.customer_id,
        c.full_name,
        c.email,
        c.city,
        c.state,
        c.segment,
        c.created_date,
        coalesce(cm.total_orders, 0) as total_orders,
        coalesce(cm.completed_orders, 0) as completed_orders,
        coalesce(cm.returned_orders, 0) as returned_orders,
        coalesce(cm.cancelled_orders, 0) as cancelled_orders,
        coalesce(cm.lifetime_value_inr, 0) as lifetime_value_inr,
        cm.first_order_date,
        cm.last_order_date
    from customers c
    left join customer_metrics cm on c.customer_id = cm.customer_id
)

select * from final
