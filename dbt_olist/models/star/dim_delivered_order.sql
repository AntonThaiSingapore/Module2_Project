
{{ config(
    materialized='table',
    description="Just the delivered orders with customer data from the raw orders table"
    ) }}

SELECT 
  o.order_id,
  SAFE_CAST(o.order_purchase_timestamp AS TIMESTAMP) AS order_purchase_timestamp,
  c.customer_unique_id,
  c.customer_city,
  c.customer_state
FROM {{ source('olist_eCommerce_1', 'public_olist_orders_dataset') }} AS o
INNER JOIN {{ source('olist_eCommerce_1', 'public_olist_customers_dataset') }} AS c
  ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
