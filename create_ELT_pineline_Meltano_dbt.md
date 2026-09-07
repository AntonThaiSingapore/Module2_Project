# Use Metano to handle end-to-end data pipeline:
ELT: Extract from Postgres on Supabase & Load to BigQuery in Google Cloud, then Transform by dbt

```
Postgres (Supabase)  ──►  BigQuery (raw)  ──►  dbt models (transformed)
    Extract + Load                               Transform
```

# Create raw data in Postgres-Supabase:
Project Name: DSAI-Project2


# E

Set up elt conda enviroment:
```
conda activate elt
```
Create Meltano project:
```
meltano init meltano-olist
```
Go to meltano-olist project folder
```
cd meltano-olist
```
Set the Python version before plugins Extractor (Taps) and Loaders (Targets): 
```
meltano config set meltano python python3.11
```
Add axtractor for Postgres to get data:
```
meltano add tap-postgres
```
config the extractor:
```
meltano config set tap-postgres --interactive
```
Test the configuration:
```
meltano config test tap-postgres
```
list all the table in Postgres:
```
meltano select tap-postgres --list  --all
```
```
meltano select tap-postgres "public-olist_orders_dataset" "*"
```
```
meltano select tap-postgres --list
```
```
meltano add target-bigquery
```
```
meltano config set target-bigquery --interactive
```

# Run Supabase (Postgres) to BigQuery

```
meltano run tap-postgres target-bigquery
```

# n this context, you don't have to do anything manually with the JSON. The target-bigquery loader takes the raw JSON (coming from the GitHub API for example) and automatically parses it, flattens the nested fields, unrolls the repeated lists, and structures it perfectly into rows and columns in BigQuery.

We also go further this time: after loading the raw data into BigQuery, we use dbt to transform it into cleaned, analytics-ready models. This completes the full ELT cycle:

Postgres (Supabase)  ──►  BigQuery (raw)  ──►  dbt models (transformed)
