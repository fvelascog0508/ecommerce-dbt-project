
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
    
    customer_unique_id,
    
    customer_city,
    customer_state,


    order_status,

    order_purchase_ts,
    order_approved_ts,
    delivered_ts,
    estimated_delivery_ts,

    -- ✅ Año-Mes
    FORMAT_TIMESTAMP('%Y-%m', order_purchase_ts) AS year_month,

    -- ✅ Orden para año-mes
    CAST(FORMAT_TIMESTAMP('%Y%m', order_purchase_ts) AS INT64) AS year_month_order,

    -- ✅ Orden de estado
    CASE order_status
        WHEN 'created' THEN 1
        WHEN 'approved' THEN 2
        WHEN 'processing' THEN 3
        WHEN 'shipped' THEN 4
        WHEN 'delivered' THEN 5
        WHEN 'invoiced' THEN 6
        WHEN 'canceled' THEN 7
        WHEN 'unavailable' THEN 8
        ELSE 99
    END AS order_status_order,
    
    -- días de entrega
    DATE_DIFF(delivered_ts, order_purchase_ts, DAY) AS delivery_days,

    DATE_DIFF(order_approved_ts, order_purchase_ts, DAY) AS approval_days,

    DATE_DIFF(delivered_ts, order_approved_ts, DAY) AS shipping_days,

    -- entrega a tiempo
    CASE 
        WHEN delivered_ts IS NOT NULL 
            AND estimated_delivery_ts IS NOT NULL
            AND delivered_ts <= estimated_delivery_ts 
        THEN 1
        ELSE 0
    END AS on_time_delivery,


    COUNT(order_item_id) AS num_items,
    SUM(price) AS gross_revenue,
    SUM(freight_value) AS total_freight

FROM {{ ref('int_orders') }}

GROUP BY
    order_id,
    customer_id,

    customer_unique_id,

    customer_city,
    customer_state,
    
    order_status,
    order_purchase_ts,
    order_approved_ts,
    delivered_ts,
    estimated_delivery_ts