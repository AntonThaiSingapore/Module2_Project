-- Create our clean Geolocation table

  {{ config(
    materialized='table',
    description="Dimensional table for the geolocation data"
    ) }}

SELECT 
    -- 1. Unique 5-digit Zip Code Prefix (Primary Key)
    geolocation_zip_code_prefix AS zip_code_prefix,
    
    -- 2. Take the average latitude and longitude for this zip code
    AVG(geolocation_lat) AS latitude,
    AVG(geolocation_lng) AS longitude,
    
    -- 3. ANY_VALUE picks one clean city and state name for this zip code
    ANY_VALUE(geolocation_city) AS city,
    ANY_VALUE(geolocation_state) AS state

  -- Start from the raw 1-million-row geolocation table
  FROM {{ source('olist_eCommerce_1', 'public_olist_geolocation_dataset') }}
  
  -- Group all duplicate zip codes together into a single row
  GROUP BY geolocation_zip_code_prefix