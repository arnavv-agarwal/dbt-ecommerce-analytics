with source as (
    select * from {{ ref('customers') }}
),

renamed as (
    select
        customer_id,
        first_name,
        last_name,
        first_name || ' ' || last_name as full_name,
        lower(email) as email,
        city,
        state,
        country,
        segment,
        created_at::date as created_date
    from source
)

select * from renamed
