-- basic title table
CREATE TABLE title_basics (
  tconst TEXT PRIMARY KEY,
  titleType TEXT,
  primaryTitle TEXT,
  originalTitle TEXT,
  isAdult SMALLINT,
  startYear TEXT,
  endYear TEXT,
  runtimeMinutes TEXT,
  genres TEXT
);

-- ratings
CREATE TABLE title_ratings (
  tconst TEXT PRIMARY KEY,
  averageRating NUMERIC(3,1),
  numVotes INTEGER
);

-- crew
CREATE TABLE title_crew (
  tconst TEXT,
  directors TEXT,
  writers TEXT
);

-- Directors name
CREATE TABLE name_basics (
  nconst TEXT PRIMARY KEY,
  primaryName TEXT,
  birthYear TEXT,
  deathYear TEXT,
  primaryProfession TEXT,
  knownForTitles TEXT
);


-- Import the .tsv files:

COPY title_basics (tconst,titleType,primaryTitle,originalTitle,isAdult,startYear,endYear,runtimeMinutes,genres)
FROM 'G:\DS\PostgreSQL Project\IMDb Project\title.basics.tsv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\N', HEADER true, QUOTE E'\b');

COPY title_ratings (tconst,averageRating,numVotes)
FROM 'G:\DS\PostgreSQL Project\IMDb Project\title.ratings.tsv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\N', HEADER true, QUOTE E'\b');

COPY title_crew (tconst, directors, writers)
FROM 'G:\DS\PostgreSQL Project\IMDb Project\title.crew.tsv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\N', HEADER true, QUOTE E'\b');

COPY name_basics (nconst, primaryName, birthYear, deathYear, primaryProfession, knownForTitles)
FROM 'G:\DS\PostgreSQL Project\IMDb Project\name.basics.tsv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\N', HEADER true, QUOTE E'\b');


-- A clean movies table:

CREATE TABLE movies AS
SELECT
  t.tconst,
  t.primaryTitle AS title,
  NULLIF(t.startYear,'\N')::int AS year,
  NULLIF(t.runtimeMinutes,'\N')::int AS runtime_minutes,
  t.genres,
  r.averageRating,
  r.numVotes
FROM title_basics t
LEFT JOIN title_ratings r ON t.tconst = r.tconst
WHERE t.titleType = 'movie';

ALTER TABLE movies ADD PRIMARY KEY (tconst);

-- Top 20 highest rated movies:
SELECT title, year, averageRating, numVotes
FROM movies
WHERE numVotes > 50000
ORDER BY averageRating DESC
LIMIT 20;

-- Top Directors by Average Movie Rating:
SELECT 
    n.primaryName AS director_name,
    unnest(string_to_array(c.directors, ',')) AS director_id,
    ROUND(AVG(r.averageRating), 2) AS avg_rating,
    COUNT(*) AS movie_count
FROM title_crew c
JOIN title_ratings r ON c.tconst = r.tconst
JOIN title_basics b ON b.tconst = c.tconst
JOIN name_basics n ON n.nconst = ANY(string_to_array(c.directors, ','))
WHERE b.titleType = 'movie'
  AND r.numVotes > 1000
GROUP BY director_id, n.primaryName
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC
LIMIT 20;
