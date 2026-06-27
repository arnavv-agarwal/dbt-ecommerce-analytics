with source as (
    select * from {{ ref('products') }}
),

renamed as (
    select
        product_id,
        product_name,
        category,
        subcategory,
        price_inr,
        cost_inr,
        {{ inr_to_usd('price_inr') }} as price_usd,
        round((price_inr - cost_inr)::numeric, 2) as gross_margin_inr,
        round(((price_inr - cost_inr) / price_inr * 100)::numeric, 2) as margin_pct,
        supplier,
        is_active
    from source
)

select * from renamed
