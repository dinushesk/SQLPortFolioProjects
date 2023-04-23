/*View the data set*/
SELECT *
FROM Analysis.Netflix_Analysis;

/*View the number of records in the dataset*/
SELECT COUNT(*)
FROM Analysis.Netflix_Analysis;

/*Check if there is any disparity in values in 'rating' columns*/
SELECT DISTINCT
    rating
FROM Analysis.Netflix_Analysis
ORDER BY rating;

/*Three values which should be under 'duration' column found in 'rating' column. Set the 3 values to 'duration' column*/
UPDATE Analysis.Netflix_Analysis
SET duration = rating
WHERE rating IN ( '66 min', '74 min', '84 min' );

/*Delete unwanted values in 'rating' column*/
DELETE FROM analysis.netflix_analysis
WHERE  rating IN ( '66 min', '74 min', '84 min' ); 

/*Add a new column for the year, movie added to Netflix  */
ALTER TABLE netflix_analysis
  ADD year VARCHAR(5) 

/* Check if all all dates in the date_added column are in the 21st century (i.e., after the year 2000)*/
SELECT DISTINCT date_added
FROM   netflix_analysis;

/*Populate the new column extracting the year from 'date_added' cloumn followed by concatenation of '20'*/
UPDATE netflix_analysis
SET    year = Concat('20', RIGHT(date_added, 2)); 

/*Check the inconsitency of the values under 'year_added' column*/
SELECT *
FROM   netflix_analysis
WHERE  Length(year_added) < 4; 

/*keep the cells with value '20' null since their year is not presented correctly*/
UPDATE netflix_analysis
SET    year_added = NULL
WHERE  Length(year_added) = 2; 

/*Check how many records are present with NULL values under column 'year_added'*/
SELECT Count(*)
FROM   netflix_analysis
WHERE  Length(year_added) IS NULL; 

/*Add a new column for the month, movie added to Netflix */
ALTER TABLE netflix_analysis
  ADD month_added VARCHAR(5); 

/*sets the new values for the 'month_added' column derived from 'date_added' column*/
UPDATE netflix_analysis
SET    month_added = LEFT(RIGHT(date_added, 6), 3); 

/*Check if the desired column is created*/
SELECT DISTINCT month_added
FROM   netflix_analysis
ORDER  BY month_added; 

/*More cleaning on the 'month_added' cloumn */
UPDATE netflix_analysis
SET    month_added = CASE
                       WHEN date_added LIKE '%Apr%' THEN 'Apr'
                       WHEN date_added LIKE '%Aug%' THEN 'Aug'
                       WHEN date_added LIKE '%Dec%' THEN 'Dec'
                       WHEN date_added LIKE '%Feb%' THEN 'Feb'
                       WHEN date_added LIKE '%Jan%' THEN 'Jan'
                       WHEN date_added LIKE '%Jul%' THEN 'Jul'
                       WHEN date_added LIKE '%Jun%' THEN 'Jun'
                       WHEN date_added LIKE '%Mar%' THEN 'Mar'
                       WHEN date_added LIKE '%May%' THEN 'May'
                       WHEN date_added LIKE '%Nov%' THEN 'Nov'
                       WHEN date_added LIKE '%Oct%' THEN 'Oct'
                       WHEN date_added LIKE '%Sep%' THEN 'Sep'
                       ELSE date_added
                     END; 
    
/*Rename a cloumn from year to year_added*/
ALTER TABLE netflix_analysis
  RENAME COLUMN year TO year_added; 

/*Correcting data inconsistencies in Ratings table*/
UPDATE analysis.ratings
SET    rating_description = Replace(rating_description, '?', '')
WHERE  rating = "ur"; 

/*Dealing with missing values*/
SELECT *
FROM   netflix_analysis
WHERE  Length(rating) < 1;

UPDATE netflix_analysis
SET    rating = 'not known'
WHERE  Length(rating) < 1;

SELECT *
FROM   netflix_analysis
WHERE  rating = 'not known'; 

SELECT *
FROM   netflix_analysis
WHERE  rating = 'not known'; 

UPDATE netflix_analysis
SET country='not known'
WHERE LENGTH(country) < 1;


