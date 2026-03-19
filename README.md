# MIS-443-PROJECT
# Getting Started

Follow the steps below to run this project correctly.

The execution order is very important.

You must run:

1. production_advwork.sql FIRST  
2. MIS_443_Project.ipynb SECOND  

---

## Step 1 — Run production_advwork.sql

Open PostgreSQL / pgAdmin and run:

production_advwork.sql

This file will:

- create the `production` schema
- create all required raw tables
- prepare the database for importing the CSV files

After running the script, import the CSV files from the `data_advwork` folder into the corresponding tables inside the `production` schema.

Expected result:

- production schema exists
- tables are created
- CSV data is loaded into PostgreSQL

---

## Step 2 — Run MIS_443_Project.ipynb

Open Jupyter Notebook and run:

MIS_443_Project.ipynb

Run the notebook from top to bottom in order.

The notebook will:

- connect Python to PostgreSQL
- load tables from the production schema
- clean and validate the data
- merge tables for analysis
- answer the project questions
- create visual charts

Expected result:

- data is cleaned
- analysis tables are created
- charts are displayed
- project questions are answered

---

## Important

Do NOT run the notebook before running production_advwork.sql.

The correct order is:

production_advwork.sql  
→ import CSV  
→ MIS_443_Project.ipynb
