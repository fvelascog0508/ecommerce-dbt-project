SELECT
    o.order_id,
    o.customer_id,

    c.customer_unique_id,
    c.customer_city,
    c.customer_state,

    o.order_status,

    o.order_purchase_ts,
    o.order_approved_ts,
    o.delivered_ts,
    o.estimated_delivery_ts,

    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value

FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_order_items') }} oi
    ON o.order_id = oi.order_id

LEFT JOIN {{ source('ecommerce', 'raw_customers') }} c
    ON o.customer_id = c.customer_id
