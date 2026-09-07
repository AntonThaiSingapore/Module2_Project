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
