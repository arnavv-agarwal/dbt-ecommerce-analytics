with products as (
    select * from {{ ref('stg_products') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

product_sales as (
    select
        oi.product_id,
        count(distinct oi.order_id) as total_orders,
        sum(oi.quantity) as total_units_sold,
        sum(oi.line_total_inr) as total_revenue_inr
    from order_items oi
    join orders o on oi.order_id = o.order_id
    where o.status_raw = 'completed'
    group by oi.product_id
),

final as (
    select
        p.product_id,
        p.product_name,
        p.category,
        p.subcategory,
        p.price_inr,
        p.cost_inr,
        p.margin_pct,
        p.supplier,
        coalesce(ps.total_orders, 0) as total_orders,
        coalesce(ps.total_units_sold, 0) as total_units_sold,
        coalesce(ps.total_revenue_inr, 0) as total_revenue_inr,
        {{ inr_to_usd('coalesce(ps.total_revenue_inr, 0)') }} as total_revenue_usd,
        round((coalesce(ps.total_units_sold, 0) * p.cost_inr)::numeric, 2) as total_cost_inr,
        round((coalesce(ps.total_revenue_inr, 0) - coalesce(ps.total_units_sold, 0) * p.cost_inr)::numeric, 2) as total_profit_inr,
        rank() over (order by coalesce(ps.total_revenue_inr, 0) desc) as revenue_rank
    from products p
    left join product_sales ps on p.product_id = ps.product_id
)

select * from final
