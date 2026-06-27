with customer_orders as (
    select * from {{ ref('int_customer_orders') }}
),

final as (
    select
        customer_id,
        full_name,
        email,
        city,
        state,
        segment,
        created_date,
        total_orders,
        completed_orders,
        returned_orders,
        cancelled_orders,
        lifetime_value_inr,
        {{ inr_to_usd('lifetime_value_inr') }} as lifetime_value_usd,
        {{ classify_customer('lifetime_value_inr') }} as customer_tier,
        first_order_date,
        last_order_date,
        case
            when last_order_date >= current_date - interval '30 days' then 'Active'
            when last_order_date >= current_date - interval '90 days' then 'At Risk'
            else 'Churned'
        end as customer_status
    from customer_orders
)

select * from final
