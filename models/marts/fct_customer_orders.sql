SELECT
    customer_unique_id,
    COUNT(*)                AS num_orders,
    SUM(gross_revenue)      AS total_revenue

FROM {{ ref('fct_orders') }}
WHERE order_status = 'delivered'
GROUP BY customer_unique_id
