
{{ config(
    materialized = 'table',
    partition_by = {
      "field": "order_purchase_ts",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by = ["customer_id", "order_status"]
) }}


SELECT
    order_id,
    customer_id,
    order_status,

    order_purchase_ts,
    order_approved_ts,
    delivered_ts,
    estimated_delivery_ts,

    COUNT(order_item_id)            AS num_items,
    SUM(price)                      AS gross_revenue,
    SUM(freight_value)              AS total_freight

FROM {{ ref('int_orders') }}

GROUP BY
    order_id,
    customer_id,
    order_status,

    order_purchase_ts,
    order_approved_ts,
    delivered_ts,
    estimated_delivery_ts