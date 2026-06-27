with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

monthly as (
    select
        date_trunc('month', order_date)::date as month,
        to_char(order_date, 'YYYY-MM') as month_label,
        count(order_id) as total_orders,
        count(case when is_completed then 1 end) as completed_orders,
        count(case when status_raw = 'returned' then 1 end) as returned_orders,
        count(case when status_raw = 'cancelled' then 1 end) as cancelled_orders,
        round(sum(case when is_completed then discounted_total_inr else 0 end)::numeric, 2) as revenue_inr,
        round(sum(case when is_completed then order_total_inr else 0 end)::numeric, 2) as gross_revenue_inr,
        round(avg(case when is_completed then discounted_total_inr end)::numeric, 2) as avg_order_value_inr
    from orders
    group by date_trunc('month', order_date), to_char(order_date, 'YYYY-MM')
),

final as (
    select
        month,
        month_label,
        total_orders,
        completed_orders,
        returned_orders,
        cancelled_orders,
        revenue_inr,
        {{ inr_to_usd('revenue_inr') }} as revenue_usd,
        gross_revenue_inr,
        avg_order_value_inr,
        round((revenue_inr - lag(revenue_inr) over (order by month)) / nullif(lag(revenue_inr) over (order by month), 0) * 100, 2) as mom_growth_pct
    from monthly
)

select * from final order by month
