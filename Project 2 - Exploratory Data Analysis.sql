-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;
-- clean data 

SELECT MAX(total_laid_off)
FROM layoffs_staging2;
-- On one day - 12000 people were laid off 

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;
-- 100% of the company was laid off (1 represents 100%)

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off =1;
-- These companys went completely under as 100% of their employees were laid off

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off =1
ORDER BY total_laid_off DESC;
-- Largest lay off by a company - Katerra with 2434 employees laid off

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off =1
ORDER BY funds_raised_millions DESC;
-- Received the most funding and went under 

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
-- Sum of employees who were let go 

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;
-- The time frame being from 2020-03-11 to 2023-03-06, about 3 years (around the beginning of COVID and post-COVID)

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
-- The industries with the highest lay offs were 'consumers' and 'retail', understandably as those industries were the most affected during COVID

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;
-- The US have the most people laid off, with 256559 in 3yrs, comparied to the other countries 

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
-- The total amount of employees laid off per year, seems to be increasing by the year 
-- In 2022 the 'SUM(total_laid_off)' was '160661' however within the first three months of 2023 the 'SUM(total_laid_off)' was  '125677'
-- The dataset ends 3months after 2023; With 2022 being the highest amount of poeple laid off but in 3months within 2023, it is already reaching the same amout as 2022

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;
-- The different series of the company - A being starting up funding 

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL 
GROUP BY `MONTH`
ORDER BY 1 ASC
;
-- All the lay offs per yyyy-mm 

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL 
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,  total_off
,SUM(total_off) OVER(ORDER BY `MONTH`) as rolling_total 
FROM Rolling_Total;
-- Rolling sum - adding the amount of people laid off by the month before
-- month by month progression of how many people were laid off - there is a difference of how many people are being laid of by the month or year

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking 
FROM  Company_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;
-- Ranking the top 5 companies who laid off the most employees per year







