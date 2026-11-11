USE netflix_analytics;
CREATE DATABASE netflix_analytics;
USE netflix_analytics;

CREATE TABLE netflix_titles (
    show_id VARCHAR(10) PRIMARY KEY,
    type VARCHAR(20),
    title VARCHAR(500),
    director TEXT,
    cast TEXT,
    country TEXT,
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(20),
    duration VARCHAR(50),
    listed_in TEXT,
    description TEXT
);

DESCRIBE netflix_titles;

SELECT COUNT(*) AS Total_Content
FROM netflix_titles;

SELECT COUNT(*) AS Total_Content
FROM netflix_titles;

SELECT
    type,
    COUNT(*) AS Total_Count
FROM netflix_titles
GROUP BY type
ORDER BY Total_Count DESC;

SELECT
    country,
    COUNT(*) AS Total_Content
FROM netflix_titles
WHERE country != 'Unknown'
GROUP BY country
ORDER BY Total_Content DESC
LIMIT 10;

SELECT
    rating,
    COUNT(*) AS total_content
FROM netflix_titles
GROUP BY rating
ORDER BY total_content DESC;

SELECT show_id, title, rating, duration
FROM netflix_titles
WHERE rating LIKE '%min%'
   OR rating LIKE '%Season%';
   
   UPDATE netflix_titles
SET duration = rating,
    rating = 'Unknown'
WHERE show_id IN ('s5542', 's5795', 's5814');

SELECT show_id, title, rating, duration
FROM netflix_titles
WHERE show_id IN ('s5542', 's5795', 's5814');

UPDATE netflix_titles
SET duration = CASE show_id
    WHEN 's5542' THEN '74 min'
    WHEN 's5795' THEN '84 min'
    WHEN 's5814' THEN '66 min'
END
WHERE show_id IN ('s5542', 's5795', 's5814');

SELECT show_id, title, rating, duration
FROM netflix_titles
WHERE show_id IN ('s5542', 's5795', 's5814');


SELECT
    rating,
    COUNT(*) AS total_content
FROM netflix_titles
WHERE rating != 'Unknown'
GROUP BY rating
ORDER BY total_content DESC;


SELECT
    release_year,
    COUNT(*) AS total_content
FROM netflix_titles
GROUP BY release_year
ORDER BY total_content DESC
LIMIT 10;

SELECT
    AVG(CAST(REPLACE(duration, ' min', '') AS UNSIGNED)) 
    AS average_movie_duration
FROM netflix_titles
WHERE type = 'Movie'
AND duration LIKE '%min%';

SELECT
    AVG(CAST(REPLACE(duration, ' Seasons', '') AS UNSIGNED))
    AS average_seasons
FROM netflix_titles
WHERE type = 'TV Show'
AND duration LIKE '%Seasons%';

SELECT
    TRIM(SUBSTRING_INDEX(
        SUBSTRING_INDEX(listed_in, ',', numbers.n),
        ',', -1
    )) AS genre,
    COUNT(*) AS total_content
FROM netflix_titles
JOIN (
    SELECT 1 AS n UNION SELECT 2 UNION SELECT 3
    UNION SELECT 4 UNION SELECT 5 UNION SELECT 6
    UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
    UNION SELECT 10
) numbers
ON CHAR_LENGTH(listed_in)
   - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
GROUP BY genre
ORDER BY total_content DESC
LIMIT 10;


SELECT
    release_year,
    SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS Movies,
    SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS TV_Shows
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year DESC
LIMIT 15;

WITH country_content AS (
    SELECT
        country,
        COUNT(*) AS total_content
    FROM netflix_titles
    WHERE country != 'Unknown'
    GROUP BY country
)
SELECT *
FROM country_content
WHERE total_content > 500
ORDER BY total_content DESC;

WITH country_content AS (
    SELECT
        country,
        COUNT(*) AS total_content
    FROM netflix_titles
    WHERE country != 'Unknown'
    GROUP BY country
)
SELECT
    country,
    total_content,
    RANK() OVER (ORDER BY total_content DESC) AS country_rank
FROM country_content
LIMIT 10;

SELECT
    TRIM(SUBSTRING_INDEX(
        SUBSTRING_INDEX(director, ',', numbers.n),
        ',', -1
    )) AS director_name,
    COUNT(*) AS total_titles
FROM netflix_titles
JOIN (
    SELECT 1 AS n UNION SELECT 2 UNION SELECT 3
    UNION SELECT 4 UNION SELECT 5
    UNION SELECT 6 UNION SELECT 7
    UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
) numbers
ON CHAR_LENGTH(director)
   - CHAR_LENGTH(REPLACE(director, ',', '')) >= numbers.n - 1
WHERE director != 'Unknown'
GROUP BY director_name
ORDER BY total_titles DESC
LIMIT 5;

SELECT
    type,
    COUNT(*) AS total_content,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM netflix_titles),
        2
    ) AS percentage
FROM netflix_titles
GROUP BY type;

SELECT
    title,
    duration
FROM netflix_titles
WHERE type = 'Movie'
AND CAST(REPLACE(duration, ' min', '') AS UNSIGNED) >
(
    SELECT AVG(
        CAST(REPLACE(duration, ' min', '') AS UNSIGNED)
    )
    FROM netflix_titles
    WHERE type = 'Movie'
    AND duration LIKE '%min%'
)
AND duration LIKE '%min%'
ORDER BY CAST(REPLACE(duration, ' min', '') AS UNSIGNED) DESC
LIMIT 10;

SELECT
    release_year,
    COUNT(*) AS total_content
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;

SELECT
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS added_year,
    COUNT(*) AS total_content
FROM netflix_titles
WHERE date_added != 'Unknown'
GROUP BY added_year
ORDER BY added_year;


WITH yearly_content AS (
    SELECT
        YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS added_year,
        COUNT(*) AS total_content
    FROM netflix_titles
    WHERE date_added != 'Unknown'
    GROUP BY added_year
)
SELECT
    added_year,
    total_content,
    LAG(total_content) OVER (
        ORDER BY added_year
    ) AS previous_year_content,
    total_content - LAG(total_content) OVER (
        ORDER BY added_year
    ) AS content_difference
FROM yearly_content
ORDER BY added_year;

SELECT
    type,
    rating,
    COUNT(*) AS total_content
FROM netflix_titles
WHERE rating != 'Unknown'
GROUP BY type, rating
ORDER BY type, total_content DESC;


SELECT
    country,
    SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS Movies,
    SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS TV_Shows,
    COUNT(*) AS Total_Content
FROM netflix_titles
WHERE country != 'Unknown'
GROUP BY country
ORDER BY Total_Content DESC
LIMIT 10;


CREATE USER 'powerbi_user'@'localhost'
IDENTIFIED BY 'Netflix@2026';

GRANT SELECT ON netflix_analytics.*
TO 'powerbi_user'@'localhost';

FLUSH PRIVILEGES;

ALTER USER 'powerbi_user'@'localhost'
IDENTIFIED BY 'Netflix@2026';

FLUSH PRIVILEGES;


SELECT COUNT(*) AS total_titles
FROM netflix_titles;



WITH Yearly_Content AS (
    SELECT
        release_year,
        COUNT(*) AS total_titles
    FROM netflix_titles
    GROUP BY release_year
)
SELECT *
FROM Yearly_Content
ORDER BY total_titles DESC;


SELECT release_year, COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY release_year
HAVING COUNT(*) > (
    SELECT AVG(year_count)
    FROM (
        SELECT COUNT(*) AS year_count
        FROM netflix_titles
        GROUP BY release_year
    ) AS yearly_data
);

SELECT
    release_year,
    COUNT(*) AS total_titles,
    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS year_rank
FROM netflix_titles
GROUP BY release_year;


SELECT
    rating,
    COUNT(*) AS total_titles,
    DENSE_RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS rating_rank
FROM netflix_titles
GROUP BY rating;


WITH Yearly_Data AS (
    SELECT
        release_year,
        COUNT(*) AS total_titles
    FROM netflix_titles
    GROUP BY release_year
)
SELECT
    release_year,
    total_titles,
    LAG(total_titles) OVER (
        ORDER BY release_year
    ) AS previous_year
FROM Yearly_Data;





WITH Yearly_Data AS (
    SELECT
        release_year,
        COUNT(*) AS total_titles
    FROM netflix_titles
    GROUP BY release_year
)
SELECT
    release_year,
    total_titles,
    SUM(total_titles) OVER (
        ORDER BY release_year
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM Yearly_Data;


SELECT
    type,
    COUNT(*) AS total_titles,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM netflix_titles
GROUP BY type;

WITH Ranked_Years AS (
    SELECT
        release_year,
        COUNT(*) AS total_titles,
        ROW_NUMBER() OVER (
            ORDER BY COUNT(*) DESC
        ) AS row_num
    FROM netflix_titles
    GROUP BY release_year
)
SELECT *
FROM Ranked_Years
WHERE row_num <= 5;


WITH Yearly_Data AS (
    SELECT
        release_year,
        COUNT(*) AS total_titles
    FROM netflix_titles
    GROUP BY release_year
),
Growth_Data AS (
    SELECT
        release_year,
        total_titles,
        LAG(total_titles) OVER (
            ORDER BY release_year
        ) AS previous_year
    FROM Yearly_Data
)
SELECT
    release_year,
    total_titles,
    previous_year,
    total_titles - previous_year AS content_change,
    ROUND(
        (total_titles - previous_year) * 100.0 /
        NULLIF(previous_year, 0),
        2
    ) AS growth_percentage
FROM Growth_Data;