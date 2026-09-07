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

To list and confrim the selection: 
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

# Create Dbt project to transfrom the data in BigQuery

```
dbt init dbt_olist
cd dbt_olist
```
Create new (separate profiles.yml) for olist project
```
dbt_olist:
  outputs:
    dev:
      dataset: olist_eCommerce
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: /home/anton/dsai/gcp_key/atomic-box-504614-c7-bd89dab05b9f.json # Use your path of key file
      location: US
      method: service-account
      priority: interactive
      project: atomic-box-504614-c7 # enter your google project id
      threads: 1
      type: bigquery
  target: dev
```

