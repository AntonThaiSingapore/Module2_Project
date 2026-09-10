-- Create our clean Products table
-- CREATE OR REPLACE TABLE dim_products AS (
  {{ config(
    materialized='table',
    description="Dimensional table for the products"
  ) }}
  
  SELECT 
    -- 1. Keep the unique product ID
    p.product_id,
    
    -- 2. Clean the category names:
    -- COALESCE looks at the English name. If it is empty (NULL), 
    -- it replaces it with the word 'unknown' instead.
    COALESCE(t.product_category_name_english, 'unknown') AS product_category_name_english,
    
    -- 3. Keep physical specifications of the product
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

  -- We start with our raw product table (we call it "p" for short)
  FROM {{ source('olist_eCommerce', 'public_olist_products_dataset') }} AS p
  
  -- We use a LEFT JOIN because we want to keep ALL products, 
  -- even if we don't find an English translation for some of them.
  LEFT JOIN {{ source('olist_eCommerce', 'product_category_name_translation') }} AS t
    ON p.product_category_name = t.product_category_name

