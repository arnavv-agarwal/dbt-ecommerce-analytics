with source as (
    select * from {{ ref('orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        order_date::date as order_date,
        {{ order_status_label('status') }} as status,
        status as status_raw,
        shipping_city,
        payment_method,
        discount_pct,
        case when status = 'completed' then true else false end as is_completed
    from source
)

select * from renamed
