
import pandas as pd
import plotly.express as px
from sqlalchemy import create_engine

# 1. Connect to BigQuery via SQLAlchemy
PROJECT_ID = "your_project_id"
engine = create_engine(f"bigquery://{PROJECT_ID}")

# 2. SQL Query string
sql_query = """
SELECT 
  product_category_name_english,
  seller_id,
  city,
  state,
  AVG(latitude) AS latitude,
  AVG(longitude) AS longitude,
  COUNT(DISTINCT order_id) AS total_orders,
  SUM(total_revenue) AS total_revenue_brl
FROM `analytics.mart_product_seller_location`
WHERE latitude IS NOT NULL AND longitude IS NOT NULL
GROUP BY product_category_name_english, seller_id, city, state
ORDER BY total_revenue_brl DESC
LIMIT 100
"""

# 3. Read into Pandas DataFrame
df_mart = pd.read_sql(sql_query, engine)

# 4. Inspect top rows
print("--- Top Sellers and Product Categories by Revenue ---")
print(df_mart.head(10))

# 5. Create Interactive Spatial Bubble Map
fig = px.scatter_mapbox(
    df_mart,
    lat="latitude",
    lon="longitude",
    size="total_revenue_brl",
    color="product_category_name_english",
    hover_name="seller_id",
    hover_data={
        "city": True, 
        "state": True, 
        "total_orders": True, 
        "total_revenue_brl": ":,.2f"
    },
    size_max=35,
    zoom=3.5,
    center={"lat": -14.2350, "lon": -51.9253},
    mapbox_style="carto-positron",
    title="Top Sellers &amp; Product Categories by Revenue (Geospatial Distribution)"
)

# 6. Clean layout margins
fig.update_layout(
    margin={"r": 0, "t": 40, "l": 0, "b": 0}
)

# 7. Display plot
fig.show()
