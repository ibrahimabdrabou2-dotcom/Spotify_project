
select * from spotify;

select * from spotify 
where duration_min =0 ;

delete from spotify 
where duration_min =0 ; 

select count (distinct artist) from spotify ;

select count (distinct track) from spotify ;

select count(distinct album) from spotify ;

select distinct album_type from spotify ;

select distinct channel from spotify  ;

-- Retrieve the names of all tracks that have more than 1 billion streams.

 select track from spotify 
 where stream > 1000000000 ;

 -- List all albums along with their respective artists.
  select distinct (album),artist  
  from spotify ;
   

 -- Get the total number of comments for tracks where licensed = TRUE

 select  sum(comments) as total_comments  from spotify 
 where licensed = 'true'  ;
 
-- Find all tracks that belong to the album type single.

select track from spotify 
where album_type = 'single' ;

--Count the total number of tracks by each artist.

select artist , count(track) as count_track from spotify 
group by  artist ;

-- Calculate the average danceability of tracks in each album. 

select album ,avg(danceability) as avg_danceability 
from spotify 
group by album 
order by avg_danceability  desc ;


-- Find the top 5 tracks with the highest energy values

select * from  spotify  
order by energy desc limit 5 ;

-- List all tracks along with their views and likes where official_video = TRUE.

select track , sum (views) as total_views , sum(likes) as total_likes 
from spotify 
where official_video = TRUE
group by track ;

-- For each album, calculate the total views of all associated tracks.

select album , track , sum(views) as total_views 
from spotify 
group by 1,2 ;

-- Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT *
FROM
(
    SELECT 
        track,
        COALESCE(
            SUM(CASE 
                WHEN most_played_on = 'Youtube' THEN stream 
            END), 0
        ) AS streamed_on_youtube,

        COALESCE(
            SUM(CASE 
                WHEN most_played_on = 'Spotify' THEN stream 
            END), 0
        ) AS streamed_on_spotify

    FROM spotify
    GROUP BY 1
) AS t1
WHERE streamed_on_spotify > streamed_on_youtube
  AND streamed_on_youtube <> 0;

--Find the top 3 most-viewed tracks for each artist using window functions.

with ranking as (
select artist , track , sum(views) as sum_views , dense_rank () over(partition by (artist) order by sum(views) desc ) as rankred
from spotify 
group by 1,2
order by 1,3 desc )
select * from ranking 
where rankred <= 3 ;


-- Write a query to find tracks where the liveness score is above the average.

select track , liveness   from spotify
where liveness >  (select avg(liveness) as avg_liveness 
from spotify ) ;


--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.


with cte 
as
(select 
       album , 
       max(energy) as hights_energy ,
       min (energy) as lowest_energy 
from spotify 
group by 1
)

select album , hights_energy-lowest_energy as energy_diff
from cte 


--  Tracks with High Energy-to-Liveness Ratio

SELECT track, energy, liveness,
energy / NULLIF(liveness, 0) AS energy_liveness_ratio 
FROM spotify
WHERE energy / NULLIF(liveness, 0) > 1.2 
ORDER BY energy_liveness_ratio DESC;


--Cumulative Likes Using Window Functions

SELECT track, views, likes,
SUM(likes) OVER ( ORDER BY views DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS cumulative_likes 
FROM spotify
ORDER BY views DESC;






















































