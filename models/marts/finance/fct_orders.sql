with 
payments as 
(
    select * from {{ ref('stg_stripe__payments') }}
),

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

order_payments as (
    select
        order_id,
        sum(case when payment_status = 'success' then payment_amount else 0 end) as amount
    from payments 
    group by order_id
),
final as (
select 
    o.order_id,
    o.customer_id,
    o.order_date,
    coalesce (op.amount, 0) as amount
from 
    orders o
left join order_payments op 
    on op.order_id = o.order_id
)
select * from final