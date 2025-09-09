# IMDb Movies Database with PostgreSQL

This project sets up and analyzes the IMDb dataset in a PostgreSQL database.
It uses IMDb’s official .tsv.gz files (non-commercial use only) and provides SQL queries for advanced movie analytics.

🚀 Features

Import IMDb datasets into PostgreSQL (title.basics, title.ratings, name.basics, title.crew, etc.).

Clean & structured movies table with ratings and metadata.

Advanced SQL queries:

Top directors by rating

Most popular genres

Yearly trends of movies

Actor/actress appearances

Longest movies

Ready for integration with Python / Data Science tools (pandas, matplotlib).

📂 Project Structure
📦 imdb-postgresql-project
 ┣ 📁 data/                # Place extracted .tsv files here
 ┣ 📁 sql/                 # SQL scripts (table creation, copy commands, queries)
 ┣ 📁 notebooks/           # (Optional) Jupyter/Python analysis
 ┣ README.md

⚙️ Setup Instructions
1. Download IMDb Dataset

Go to 👉 https://datasets.imdbws.com/

Download and extract these files (using 7-Zip on Windows):

title.basics.tsv.gz

title.ratings.tsv.gz

name.basics.tsv.gz

title.crew.tsv.gz

(Optional: title.principals.tsv.gz, title.akas.tsv.gz, title.episode.tsv.gz)
