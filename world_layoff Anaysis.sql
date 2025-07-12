CREATE DATABASE WORLD_LAYOFFS;
USE WORLD_LAYOFFS;

SELECT * FROM LAYOFFS;

SELECT 
    MAX(total_laid_off)
FROM
    LAYOFFS;
    
SELECT 
    MAX(total_laid_off), MAX(percentage_laid_off)
FROM
    LAYOFFS;
    
-- Which companies had 1 which is basically 100 percent of they company laid off

SELECT * FROM LAYOFFS
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC ;

-- if we order by funcs_raised_millions we can see how big some of these companies were

SELECT * FROM LAYOFFS
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with the biggest single Layoff

SELECT COMPANY, total_laid_off
FROM LAYOFFS ORDER BY total_laid_off DESC;

-- Companies with the most Total Layoffs
SELECT COMPANY, SUM(total_laid_off)
FROM LAYOFFS
GROUP BY COMPANY 
ORDER BY SUM(total_laid_off) DESC;

-- by location

SELECT LOCATION, SUM(total_laid_off)
FROM LAYOFFS
GROUP BY LOCATION
ORDER BY SUM(total_laid_off) DESC;

-- this it total in the past 3 years or in the dataset

SELECT COUNTRY,  SUM(total_laid_off)
FROM LAYOFFS
GROUP BY COUNTRY
ORDER BY SUM(total_laid_off) DESC;

SELECT YEAR(DATE), SUM(total_laid_off)
FROM LAYOFFS
GROUP BY YEAR(DATE)
ORDER BY YEAR(DATE) ASC;

SELECT INDUSTRY, SUM(total_laid_off)
FROM LAYOFFS
GROUP BY INDUSTRY
ORDER BY  SUM(total_laid_off) DESC;

SELECT STAGE, SUM(total_laid_off)
FROM LAYOFFS
GROUP BY STAGE
ORDER BY SUM(total_laid_off) DESC;

-- Rolling Total of Layoffs Per Month.

SELECT SUBSTRING('DATE', 1, 7) AS 'MONTHS', SUM(total_laid_off)
FROM LAYOFFS
WHERE SUBSTRING('DATE', 1, 7)  IS NOT NULL
GROUP BY 'MONTHS'
ORDER BY 1 ASC;

WITH ROLLING_TOTAL AS
(
SELECT SUBSTRING('DATE', 1, 7) AS 'MONTHS', SUM(total_laid_off) AS total_off
FROM LAYOFFS
WHERE SUBSTRING('DATE', 1, 7)  IS NOT NULL
GROUP BY 'MONTHS'
ORDER BY 1 ASC
)
SELECT 'MONTHS', SUM(total_off) OVER(ORDER BY 'MONTHS')
FROM ROLLING_TOTAL;

SELECT COMPANY, YEAR('date'), SUM(total_laid_off)
FROM LAYOFFS
GROUP BY COMPANY, YEAR('date')
ORDER BY  SUM(total_laid_off)  ASC;

WITH COMPANY_YEAR (company, years, total_laid_off) AS 
(
SELECT COMPANY, YEAR('date'), SUM(total_laid_off) 
FROM LAYOFFS
GROUP BY COMPANY, YEAR('date')
),
 Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

