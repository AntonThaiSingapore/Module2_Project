-- Create a location-enriched dim table: Product Category-Seller-Location by Revenue

  {{ config(
    materialized='table',
    description="OrderItems and Seller's latitude and longitude to every delivered order"
  ) }}
SELECT
/*-- Lookup Product Category Name in English (default to 'unknown' if not found)
    COALESCE(t.product_category_name_english, 'unknown') AS product_category_name_english,
*/

    dp.product_category_name_english,
    oi.seller_id,
    oi.order_id,


    

-- Location Details (using Seller location for seller-map analysis)
    s.seller_city AS city,
    UPPER(s.seller_state) AS state,
    g.latitude,
    g.longitude,
    
-- Revenue Aggregations
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue

-- Start from the raw order items table
  FROM {{ source('olist_eCommerce_1', 'public_olist_order_items_dataset') }} AS oi
  
-- Join Orders table to filter for completed deliveries only
  INNER JOIN {{ source('olist_eCommerce_1', 'public_olist_orders_dataset') }} AS o
    ON oi.order_id = o.order_id
    
/*-- Join Products table
  INNER JOIN {{ source('olist_eCommerce_1', 'public_olist_products_dataset') }} AS p
    ON oi.product_id = p.product_id
    
  -- Left Join English Category Translation map
  LEFT JOIN {{ source('olist_eCommerce_1', 'public_product_category_name_translation') }} AS t
    ON p.product_category_name = t.product_category_name
  */

-- Join dim_product to get the product category name in English
  INNER JOIN {{ source('olist_eCommerce', 'dim_product') }} AS dp 
    ON oi.product_id = dp.product_id

  
    -- Join Seller details
  INNER JOIN {{ source('olist_eCommerce_1', 'public_olist_sellers_dataset') }} AS s
    ON oi.seller_id = s.seller_id
    
  -- Left Join deduplicated Geolocation dimension to attach Lat/Lng coordinates
  LEFT JOIN {{ source('olist_eCommerce', 'dim_geolocation') }} AS g
    ON s.seller_zip_code_prefix = g.zip_code_prefix

-- Filter for delivered transactions
  WHERE o.order_status = 'delivered'

-- Group by requested dimensions
  GROUP BY 
    dp.product_category_name_english,
    oi.seller_id,
    oi.order_id,
    s.seller_city,
    s.seller_state,
    g.latitude,
    g.longitude


