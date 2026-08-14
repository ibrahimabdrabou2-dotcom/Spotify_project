🎵 Spotify Advanced SQL Data Analysis Project

Advanced SQL | PostgreSQL | Data Analysis | Query Optimization



📌 Project Overview

This project focuses on analyzing Spotify music data using PostgreSQL and advanced SQL techniques.

The goal is to transform a raw Spotify dataset into meaningful analytical insights while demonstrating practical SQL skills used by Data Analysts, including:

Data Exploration & Cleaning ,
Aggregation & Grouping ,
Subqueries ,
Common Table Expressions (CTEs) ,
Window Functions ,
Conditional Aggregation ,
Ranking ,
Query Optimization  ,
Indexing  ,
Execution Plan Analysis using EXPLAIN ANALYZE  ,

The project contains a series of 15 SQL practice questions divided into Easy, Medium, and Advanced levels.



Business Objective

The analysis aims to answer questions related to:

Most-streamed tracks  ,
Artist and album performance ,
Track popularity  ,
Audio characteristics such as Energy and Danceability  ,
Spotify vs YouTube performance  ,
Top-performing tracks for each artist  ,
Track engagement through Views, Likes, and Comments  ,
Query performance and database optimization  ,

The project is designed not only to practice SQL syntax, but also to demonstrate how SQL can be used to extract business-oriented insights from real-world data.


🔎 Project Workflow



1. Data Exploration

The first step was understanding the structure and characteristics of the dataset.

Examples of exploratory analysis include:

Inspecting the dataset  ,
Counting distinct artists  ,
Counting distinct tracks  ,
Counting distinct albums  , 
Identifying album types  ,
Identifying available platforms/channels  ,
Checking invalid values  , 


Example:

SELECT COUNT(DISTINCT artist) AS total_artists

FROM spotify;


SELECT COUNT(DISTINCT track) AS total_tracks  

FROM spotify;

SELECT COUNT(DISTINCT album) AS total_albums

FROM spotify;



2. Data Cleaning

Before performing the analysis, the dataset was checked for invalid or problematic records.

For example, tracks with a duration of 0 minutes were identified and removed.

SELECT * 

FROM spotify

WHERE duration_min = 0;

After identifying these records:

DELETE FROM spotify

WHERE duration_min = 0;

This ensures that invalid records do not affect the analytical results.


📊 SQL Analysis

The project contains 15 SQL questions divided into three difficulty levels.



🟢 Easy Level
1. Tracks with More Than 1 Billion Streams

Identify tracks that have more than 1 billion streams.

SELECT track

FROM spotify

WHERE stream > 1000000000;


2. Albums and Their Artists
SELECT DISTINCT album, artist
FROM spotify;



3. Total Comments for Licensed Tracks 
SELECT SUM(comments) AS total_comments 
FROM spotify
WHERE licensed = TRUE;
4. Tracks from Single Releases
SELECT track
FROM spotify
WHERE album_type = 'single';
5. Number of Tracks per Artist
SELECT
    artist,
    COUNT(track) AS total_tracks
FROM spotify
GROUP BY artist
ORDER BY total_tracks DESC;


🟡 Medium Level
6. Average Danceability by Album
SELECT
    album,
    AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;
7. Top 5 Tracks by Energy
SELECT *
FROM spotify
ORDER BY energy DESC
LIMIT 5;
8. Views and Likes for Official Videos
SELECT
    track,
    SUM(views) AS total_views,
    SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE
GROUP BY track
ORDER BY total_views DESC;
9. Total Views by Album and Track
SELECT
    album,
    track,
    SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC;
10. Tracks Streamed More on Spotify Than YouTube

This analysis uses Conditional Aggregation with CASE WHEN.

SELECT *
FROM
(
    SELECT
        track,

        COALESCE(
            SUM(
                CASE
                    WHEN most_played_on = 'Youtube'
                    THEN stream
                END
            ), 0
        ) AS streamed_on_youtube,

        COALESCE(
            SUM(
                CASE
                    WHEN most_played_on = 'Spotify'
                    THEN stream
                END
            ), 0
        ) AS streamed_on_spotify

    FROM spotify
    GROUP BY track
) AS platform_comparison

WHERE streamed_on_spotify > streamed_on_youtube
  AND streamed_on_youtube <> 0;
🔴 Advanced Level
11. Top 3 Most-Viewed Tracks for Each Artist

This analysis demonstrates the use of:

CTE
DENSE_RANK()
PARTITION BY
Aggregation
WITH ranking AS
(
    SELECT
        artist,
        track,
        SUM(views) AS total_views,

        DENSE_RANK() OVER
        (
            PARTITION BY artist
            ORDER BY SUM(views) DESC
        ) AS rank
    FROM spotify
    GROUP BY artist, track
)

SELECT *
FROM ranking
WHERE rank <= 3
ORDER BY artist, rank;
12. Tracks Above Average Liveness

A subquery is used to calculate the overall average liveness score.

SELECT
    track,
    liveness
FROM spotify
WHERE liveness >
(
    SELECT AVG(liveness)
    FROM spotify
);
13. Energy Difference Between Highest and Lowest Values

This analysis demonstrates how a CTE can simplify a multi-step calculation.

WITH cte AS
(
    SELECT
        album,
        MAX(energy) AS highest_energy,
        MIN(energy) AS lowest_energy
    FROM spotify
    GROUP BY album
)

SELECT
    album,
    highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY energy_diff DESC;

Note: highest_energy, lowest_energy, and energy_diff use consistent naming to keep the query clean and readable.

14. Tracks with High Energy-to-Liveness Ratio
SELECT
    track,
    energy,
    liveness,
    energy / NULLIF(liveness, 0) AS energy_liveness_ratio
FROM spotify
WHERE energy / NULLIF(liveness, 0) > 1.2
ORDER BY energy_liveness_ratio DESC;
15. Cumulative Likes Using Window Functions

This analysis demonstrates the use of a cumulative window calculation.

SELECT
    track,
    views,
    likes,

    SUM(likes) OVER
    (
        ORDER BY views DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_likes

FROM spotify
ORDER BY views DESC;
⚡ Query Optimization

One of the main objectives of this project was to understand how database indexing can affect query performance.

Step 1 — Analyze the Query

The query was first tested using:

EXPLAIN ANALYZE
SELECT *
FROM spotify
WHERE artist = 'Artist Name';

The execution plan was then reviewed to understand how PostgreSQL was processing the query.

Before Optimization

📸 Execution Plan Before Index




Replace the image above with your actual EXPLAIN ANALYZE screenshot.

Step 2 — Create an Index

An index was created on the frequently filtered artist column:

CREATE INDEX idx_spotify_artist
ON spotify(artist);
Step 3 — Analyze the Query Again

The same query was executed again:

EXPLAIN ANALYZE
SELECT *
FROM spotify
WHERE artist = 'Artist Name';
After Optimization

📸 Execution Plan After Index




📈 Performance Comparison
Metric	Before Index	After Index
Execution Time	7 ms*	0.153 ms*
Planning Time	0.17 ms*	0.152 ms*

*Values should reflect the final EXPLAIN ANALYZE results from the current PostgreSQL environment.

Performance Visualization




The comparison demonstrates how indexing can reduce the amount of work required to locate records when filtering on an indexed column.

Important: Actual performance depends on dataset size, PostgreSQL configuration, hardware, cache state, and query structure. For small datasets, PostgreSQL may still prefer a sequential scan.

💡 Key Analytical Insights

The SQL analysis is designed to generate actionable insights such as:

🎵 Track Performance

Identify the tracks receiving the highest number of streams and views.

👤 Artist Performance

Determine which artists have the highest number of tracks and identify their top-performing tracks.

💿 Album Performance

Compare albums based on total views and audio characteristics such as average danceability.

🔥 Audio Characteristics

Analyze tracks with the highest energy and compare energy levels across albums.

📱 Platform Performance

Compare Spotify and YouTube streaming performance to identify tracks performing better on each platform.

❤️ Audience Engagement

Use views, likes, and comments to understand how audiences interact with different tracks.

⚡ Database Performance

Demonstrate how indexing can improve query execution when filtering large datasets.

🛠️ Skills Demonstrated

This project demonstrates practical experience with:

SQL
SELECT
WHERE
GROUP BY
ORDER BY
HAVING
DISTINCT
Aggregate Functions
CASE WHEN
COALESCE
NULLIF
Subqueries
CTEs
Window Functions
DENSE_RANK()
PARTITION BY
SUM() OVER()
Conditional Aggregation
Database Concepts
PostgreSQL
Data Cleaning
Indexing
Query Execution Plans
Query Optimization
Performance Analysis
Analytical Skills
Exploratory Data Analysis
Data Aggregation
Performance Comparison
Business-Oriented Analysis
Insight Generation
🧰 Technology Stack
Tool	Purpose
PostgreSQL	Database & SQL Analysis
pgAdmin 4	Database Management
SQL	Data Analysis & Querying
GitHub	Project Documentation & Version Control
📁 Project Structure
Spotify_project/
│
├── README.md
├── Spotify_queres.sql
├── cleaned_dataset.csv
├── Spotify logo.jpeg
│
└── screenshots/
    ├── explain_before.png
    ├── explain_after.png
    └── performance_comparison.png
▶️ How to Run the Project
1. Install PostgreSQL

Install PostgreSQL and pgAdmin 4.

2. Create the Database

Create a new PostgreSQL database for the project.

3. Create the Table

Run the table creation script using the columns defined in the SQL file.

4. Import the Dataset

Import cleaned_dataset.csv into the spotify table.

5. Run the SQL Queries

Open:

Spotify_queres.sql

and execute the queries in PostgreSQL / pgAdmin.

6. Test Query Optimization

Run the EXPLAIN ANALYZE query before and after creating the index.

📸 Project Screenshots
Data Exploration



SQL Analysis

Query Optimization — Before




Query Optimization — After




Performance Comparison




Add the screenshots to the screenshots folder using the filenames above.

📚 What I Learned

Through this project, I strengthened my ability to:

Work with PostgreSQL databases.

Explore and clean real-world datasets.

Write SQL queries at different levels of complexity.

Use CTEs to structure complex queries.

Apply Window Functions to analytical problems.

Compare performance before and after indexing.

Read and interpret query execution plans.

Translate raw data into meaningful analytical questions.

Think about SQL from both an analytical and performance perspective.

🚀 Future Improvements

Potential future improvements include:

Building an interactive Power BI dashboard from the analyzed data.

Adding more advanced SQL performance experiments.

Testing queries on larger datasets.

Creating additional analytical KPIs.

Comparing Spotify and YouTube performance in greater detail.

Automating the data-cleaning process.

Adding more business-focused insights.



👨‍💻 Author

Ibrahim Abdrabou


































































































































