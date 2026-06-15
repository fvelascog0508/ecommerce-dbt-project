SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value,
    CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_ts

FROM {{ source('ecommerce', 'raw_order_items') }}
