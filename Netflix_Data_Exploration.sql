/*View the data set*/
SELECT *
FROM   analysis.netflix_analysis;

/*View the number of records in the dataset*/
SELECT Count(*)
FROM   analysis.netflix_analysis;

/*View Movie and TV show distribution as a count and % */
SELECT type,
       Count(type),
       Round(Count(type) * 100 * 1.00 / (SELECT Count(*)
                                         FROM   analysis.netflix_analysis), 0)
       AS
       percentage
FROM   analysis.netflix_analysis
GROUP  BY type; 

/*View Movies and TV show count by release year % */
SELECT release_year,
       Sum(CASE
             WHEN type = 'movie' THEN 1
             ELSE 0
           END) AS Movie_count,
       Sum(CASE
             WHEN type = 'tv show' THEN 1
             ELSE 0
           END) AS TVshow_count
FROM   analysis.netflix_analysis
GROUP  BY release_year
ORDER  BY release_year;

/*View the running total of Movie and TV Show Count by release year*/
SELECT  release_year,
		sum(TVshow_count) over (order by release_year) AS TVShow_running_total,
        sum(movie_count) over (order by release_year) AS TVShow_running_total
FROM     (
                  SELECT   release_year,
                           sum(case when type='tv show' then 1 else 0 end) as TVshow_count,
                           sum(CASE WHEN type='movie' THEN 1 ELSE 0 END) AS movie_count
                  FROM     analysis.netflix_analysis
                  GROUP BY release_year
		  ) t1;

/*View Movie and TV show distribution by rating % */
SELECT rating,
       Sum(CASE
             WHEN type = 'movie' THEN 1
             ELSE 0
           END) AS Movie_count,
       Sum(CASE
             WHEN type = 'tv show' THEN 1
             ELSE 0
           END) AS TVshow_count
FROM   analysis.netflix_analysis
WHERE  rating IS NOT NULL
       AND rating <> ''
GROUP  BY rating
ORDER  BY movie_count DESC; 

/*View the movie name with the duration in min and the country % */				
SELECT title,
       country,
       durationm
FROM   (SELECT title,
               country,
               duration,
               COALESCE(Trim(Replace(duration, 'min', '')), 0) AS durationM
        FROM   netflix_analysis
        WHERE  type = 'Movie'
        ORDER  BY Cast(COALESCE(Trim(Replace(duration, 'min', '')), 0) AS
                       DECIMAL(20, 2)) DESC)t
WHERE  durationm > 180
       AND country IS NOT NULL
       AND country <> ''
ORDER  BY durationm; 
    
/*Create a Common Table Expression to list all the movies with duration greater than 180 min and view only UNITED STATES movies*/
    
WITH longmovies
     AS (SELECT title,
                country,
                durationm,
                date_added
         FROM   (SELECT title,
                        country,
                        duration,
                        COALESCE(Trim(Replace(duration, 'min', '')), 0) AS
                        durationM,
                        date_added
                 FROM   netflix_analysis
                 WHERE  type = 'Movie'
                 ORDER  BY Cast(COALESCE(Trim(Replace(duration, 'min', '')), 0)
                                AS
                                DECIMAL(20, 2)) DESC)t
         WHERE  durationm > 180
                AND country IS NOT NULL
                AND country <> ''
         ORDER  BY durationm)
SELECT title
FROM   longmovies
WHERE  country LIKE '%United%';
    
/* View a distribution of United States and Indian movie from CTE*/
    SELECT Sum(CASE
             WHEN country LIKE '%United%' THEN 1
             ELSE 0
           END) AS UnitedStates_Count,
       Sum(CASE
             WHEN country LIKE '%india%' THEN 1
             ELSE 0
           END) India_Count
FROM   longmovies; 
    
/* View a list of American movies from CTE with date added to netflix*/
 SELECT title,
       date_added
FROM   longmovies
WHERE  country LIKE '%United%'
ORDER  BY title; 
    
          
/*Number of movies added to netflix by year*/
SELECT year_added,
       Count(*) as Movie_Count
FROM   analysis.netflix_analysis
WHERE  type = 'Movie'
GROUP  BY year_added;


/*Number of movies added to netflix by month*/
SELECT year_added,
       Sum(CASE
             WHEN type = 'movie' THEN 1
             ELSE 0
           END) AS Movie_count,
       Sum(CASE
             WHEN type = 'tv show' THEN 1
             ELSE 0
           END) AS TVshow_count
FROM   analysis.netflix_analysis
GROUP  BY year_added; 
 
 /*View movie type and their count by year added to netflix*/
 USE analysis;
 SELECT year_added,
       Sum(CASE
             WHEN listed_in LIKE '%Action & Adventure%' THEN 1
             ELSE 0
           END) AS Action_Adventure,
       Sum(CASE
             WHEN listed_in LIKE '%Anime Features%' THEN 1
             ELSE 0
           END) AS Anime_Features,
       Sum(CASE
             WHEN listed_in LIKE '%Children & Family Movies%' THEN 1
             ELSE 0
           END) AS Children_Family_Movies,
       Sum(CASE
             WHEN listed_in LIKE '%Comedies%' THEN 1
             ELSE 0
           END) AS Comedies,
       Sum(CASE
             WHEN listed_in LIKE '%Documentaries%' THEN 1
             ELSE 0
           END) AS Documentaries,
       Sum(CASE
             WHEN listed_in LIKE '%Dramas%' THEN 1
             ELSE 0
           END) AS Dramas,
       Sum(CASE
             WHEN listed_in LIKE '%Horror Movies%' THEN 1
             ELSE 0
           END) AS Horror_Movies,
       Sum(CASE
             WHEN listed_in LIKE '%International Movies%' THEN 1
             ELSE 0
           END) AS International_Movies,
       Sum(CASE
             WHEN listed_in LIKE '%Romantic Movies%' THEN 1
             ELSE 0
           END) AS Romantic_Movies,
       Sum(CASE
             WHEN listed_in LIKE '%Sci-Fi & Fantasy%' THEN 1
             ELSE 0
           END) AS Sci_Fi_Fantasy,
       Sum(CASE
             WHEN listed_in LIKE '%Sports Movies%' THEN 1
             ELSE 0
           END) AS Sports_Movies,
       Sum(CASE
             WHEN listed_in LIKE '%Thrillers%' THEN 1
             ELSE 0
           END) AS Thrillers,
       Sum(CASE
             WHEN listed_in LIKE '%Anime Series%' THEN 1
             ELSE 0
           END) AS Anime_Series,
       Sum(CASE
             WHEN listed_in LIKE '%Faith & Spirituality%' THEN 1
             ELSE 0
           END) AS Faith_Spirituality,
       Sum(CASE
             WHEN listed_in LIKE '%Independent Movies%' THEN 1
             ELSE 0
           END) AS Independent_Movies
FROM   netflix_analysis
GROUP  BY year_added;

 /*List down all Horror movies with year added 2020*/
 SELECT year_added,
		month_added,
       title
FROM   netflix_analysis
WHERE  listed_in LIKE '%Horror Movies%'
       AND year_added = 2020;
       
/* List Movie categories and movie count by year added to netflix*/
With cte as (
SELECT year_added,
sum(case when listed_in like '%Action & Adventure%' then 1 else 0 end) as Action_Adventure,
sum(case when listed_in like '%Anime Features%' then 1 else 0 end) as Anime_Features,
sum(case when listed_in like '%Children & Family Movies%' then 1 else 0 end) as Children_Family_Movies,
sum(case when listed_in like '%Comedies%' then 1 else 0 end) as Comedies,
sum(case when listed_in like '%Documentaries%' then 1 else 0 end) as Documentaries,
sum(case when listed_in like '%Dramas%' then 1 else 0 end) as Dramas,
sum(case when listed_in like '%Horror Movies%' then 1 else 0 end) as Horror_Movies,
sum(case when listed_in like '%International Movies%' then 1 else 0 end) as International_Movies,
sum(case when listed_in like '%Romantic Movies%' then 1 else 0 end) as Romantic_Movies,
sum(case when listed_in like '%Sci-Fi & Fantasy%' then 1 else 0 end) as Sci_Fi_Fantasy,
sum(case when listed_in like '%Sports Movies%' then 1 else 0 end) as Sports_Movies,
sum(case when listed_in like '%Thrillers%' then 1 else 0 end) as Thrillers,
sum(case when listed_in like '%Anime Series%' then 1 else 0 end) as Anime_Series,
sum(case when listed_in like '%Faith & Spirituality%' then 1 else 0 end) as Faith_Spirituality,
sum(case when listed_in like '%Independent Movies%' then 1 else 0 end) as Independent_Movies
from Netflix_Analysis 
group by year_added 
),
G1 as (
select year_added,'Action_Adventure' as movie_category,sum(Action_Adventure) as movie_count from cte group by year_added union all
select year_added,'Anime_Features' as movie_category,sum(Anime_Features) as movie_count from cte group by year_added union all
select year_added,'Children_Family_Movies' as movie_category,sum(Children_Family_Movies) as movie_count from cte group by year_added union all
select year_added,'Comedies' as movie_category,sum(Comedies) as movie_count from cte group by year_added union all
select year_added,'Documentaries' as movie_category,sum(Documentaries) as movie_count from cte group by year_added union all
select year_added,'Dramas' as movie_category,sum(Dramas) as movie_count from cte group by year_added union all
select year_added,'Horror_Movies' as movie_category,sum(Horror_Movies) as movie_count from cte group by year_added union all
select year_added,'International_Movies' as movie_category,sum(International_Movies) as movie_count from cte group by year_added union all
select year_added,'Romantic_Movies' as movie_category,sum(Romantic_Movies) as movie_count from cte group by year_added union all
select year_added,'Sci_Fi_Fantasy' as movie_category,sum(Sci_Fi_Fantasy) as movie_count from cte group by year_added union all
select year_added,'Sports_Movies' as movie_category,sum(Sports_Movies) as movie_count from cte group by year_added union all
select year_added,'Thrillers' as movie_category,sum(Thrillers) as movie_count from cte group by year_added union all
select year_added,'Anime_Series' as movie_category,sum(Anime_Series) as movie_count from cte group by year_added union all
select year_added,'Faith_Spirituality' as movie_category,sum(Faith_Spirituality) as movie_count from cte group by year_added union all
select year_added,'Independent_Movies' as movie_category,sum(Independent_Movies) as movie_count from cte group by year_added
)
select * from G1;

/*View all Sri Lankan TV shows and Movies */
SELECT *
FROM   analysis.netflix_analysis
WHERE  country LIKE '%Sri%'; 

/*Movie and TVshow Count by country wise*/
WITH summary
     AS (SELECT DISTINCT Trim(country) AS country,
                         Sum(count)    AS movie_TVshow_count
         FROM   (SELECT Substring_index(Substring_index(country, ',',
                                        n.digit + 1),
                        ',', -1) AS
                                country,
                        Count(*)
                        AS
                                count,
                        n.digit
                 FROM   netflix_analysis
                        INNER JOIN (SELECT 0 digit
                                    UNION ALL
                                    SELECT 1
                                    UNION ALL
                                    SELECT 2
                                    UNION ALL
                                    SELECT 3
                                    UNION ALL
                                    SELECT 4
                                    UNION ALL
                                    SELECT 5
                                    UNION ALL
                                    SELECT 6
                                    UNION ALL
                                    SELECT 7
                                    UNION ALL
                                    SELECT 8
                                    UNION ALL
                                    SELECT 9) n
                                ON n.digit < Length(country) - Length(
                                             Replace(country, ',', ''))
                                             + 1
                 GROUP  BY country,
                           n.digit
                 ORDER  BY country) t
         GROUP  BY country)
SELECT country,
       movie_tvshow_count
FROM   summary
GROUP  BY country
ORDER  BY movie_tvshow_count DESC;

/*Creat a temporary table with thriller and horror tvshows and movies*/

DROP TABLE IF exists HorrorAndThriller;
CREATE TABLE HorrorAndThriller
	(year_added varchar (6), 
    month_added varchar (6), 
    title varchar (100), 
    listed_in varchar (150), 
    director varchar (150),
    country varchar (150),
    type varchar (20)
    );
INSERT INTO HorrorAndThriller
SELECT year_added,
		month_added,
      title,
       listed_in,
     director,
     country,
      type
FROM   analysis.netflix_analysis
WHERE  listed_in LIKE '%Horror Movies%' OR listed_in LIKE '%Thrillers%'
ORDER BY director DESC;
SELECT * from horrorandthriller;







          



