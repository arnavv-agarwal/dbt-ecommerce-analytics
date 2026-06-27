with source as (
    select * from {{ ref('order_items') }}
),

renamed as (
    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price_inr,
        {{ inr_to_usd('unit_price_inr') }} as unit_price_usd,
        round((quantity * unit_price_inr)::numeric, 2) as line_total_inr,
        {{ inr_to_usd('quantity * unit_price_inr') }} as line_total_usd
    from source
)

select * from renamed
