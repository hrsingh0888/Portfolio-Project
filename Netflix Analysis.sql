CREATE DATABASE Netfilx_db_1;
USE Netfilx_db_1;
SELECT * FROM Netflix_titles;

SELECT COUNT(*) AS TOTAL_COUNT FROM Netflix_titles;

SELECT DISTINCT
    (TYPE)
FROM
    Netflix_titles;
    
-- 1. COUNT NUMBER OF MOVIES VS TV SHOW

SELECT 
    TYPE, COUNT(*) AS Total_content
FROM
    Netflix_titles
GROUP BY type;

-- 2.Find most common rating for movies and Tv Shows

SELECT TYPE, RATING FROM
(SELECT TYPE, RATING,
    COUNT(*), 
    RANK() OVER(partition by TYPE ORDER BY COUNT(*) DESC) AS Ranking
from Netflix_titles 
GROUP BY 1, 2) AS T1
WHERE 
    RANKING = 1;

-- 3.LIST ALL THE MOVIES RELEASE IN A SPECIFIC YEAR(e.g; 2020)

SELECT 
    *
FROM
    Netflix_titles
WHERE
    type = 'Movie' AND Release_year = 2020
    
-- 4.FIND TOP COUNTRIES WITH MOST CONTENT ON NETFLIX

SELECT 
    COUNTRY, COUNT(Show_id) AS Total_Contet
FROM
    Netflix_titles
GROUP BY COUNTRY
LIMIT 5;

-- 5.IDENTIFY THE LONGEST MOVIE OR TV SHOWS BY DURATION

SELECT 
    *
FROM
    Netflix_titles
WHERE
    type = 'Movie'
        AND duration = (SELECT 
            MAX(duration)
        FROM
            Netflix_titles)
            
-- 6.FIND CONTENT ADDED IN LAST 2 YEARS

SELECT * 
FROM Netflix_titles
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 2 YEAR;

-- 7. Find all the movies/TV shows by director 'Haile Gerima'

SELECT * FROM Netflix_titles where director = 'Haile Gerima'

-- 8.List all TV Shows with more that 2 Season

SELECT *
FROM Netflix_titles
WHERE type = 'TV Shows'
  AND CAST(
        SUBSTRING_INDEX(duration, ' ', 1)
      AS UNSIGNED
      ) > 2;
      
-- 9.Count the number of content items in each genre

WITH RECURSIVE split_genres AS (
  SELECT 
    show_id,
    TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
    SUBSTRING(listed_in, LENGTH(SUBSTRING_INDEX(listed_in, ',', 1)) + 2) AS rest
  FROM netflix_titles
  WHERE listed_in IS NOT NULL

  UNION ALL

  SELECT 
    show_id,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS genre,
    SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
  FROM split_genres
  WHERE rest != ''
)

SELECT 
  genre,
  COUNT(*) AS total_content
FROM 
  split_genres
GROUP BY 
  genre
ORDER BY 
  total_content DESC;
  
-- 10.Find each year and the average number of content release in India on netflix return top 5 year with highest avg content release!

SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')) AS YEAR,
    COUNT(*),
    COUNT(*) / (SELECT 
            COUNT(*)
        FROM
            netflix_titles
        WHERE
            COUNTRY = 'INDIA') AS Avg_Content
FROM
    netflix_titles
WHERE
    Country = 'India'
GROUP BY 1

-- 11. List all movies that are documentaries

SELECT 
    TYPE, Title
FROM
    NETFLIX_TITLES
WHERE
    LISTED_In = 'Documentaries'

-- 12.Find all the content without a director

SELECT 
    TYPE, TITLE
FROM
    NETFLIX_TITLES
WHERE
    DIRECTOR IS NULL;
    
-- 13.Find how many movies actor 'Jitendra Kumar' apperead in last 5 years

SELECT 
    *
FROM
    netflix_titles
WHERE
    CAST LIKE '%Jitendra Kumar%'
        AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 5;
        
-- 14.Find the top 10 actors who have apperead in the highest number of movies produced.

SELECT actor, COUNT(*) AS total_content
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 1), ',', -1)) AS actor FROM netflix_titles WHERE cast IS NOT NULL
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 2), ',', -1)) FROM netflix_titles WHERE cast IS NOT NULL
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 3), ',', -1)) FROM netflix_titles WHERE cast IS NOT NULL
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 4), ',', -1)) FROM netflix_titles WHERE cast IS NOT NULL
    UNION ALL
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 5), ',', -1)) FROM netflix_titles WHERE cast IS NOT NULL
) AS all_actors
WHERE actor != ''
GROUP BY actor
ORDER BY total_content DESC;

/*15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category*/

SELECT 
    category AS listed_in,
    type,
    COUNT(*) AS content_count
FROM (
    SELECT 
        type,
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix_titles
    WHERE description IS NOT NULL
) AS categorized_content
GROUP BY category, type
ORDER BY type;

SELECT * FROM NETFLIX_TITLES