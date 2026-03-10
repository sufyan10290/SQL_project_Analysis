--Cast Date-time(Timestamp) AS Date
SELECT job_title_short,
    job_location,
    job_posted_date::Date AS post_date
FROM job_postings_fact
LIMIT 10;
-- Convert Date-time to a different Time Zone using AT TIME ZONE
-- Asume current values in UTC
SELECT job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS post_date
FROM job_postings_fact
LIMIT 10;
-- Extract specific Date parts Eg (Day, Year, Month)
SELECT job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS post_date,
    EXTRACT(
        MONTH
        FROM job_posted_date
    ) AS MONTH
FROM job_postings_fact
LIMIT 10;
-- Retrieve job postings by month
SELECT COUNT(job_id),
    EXTRACT(
        MONTH
        FROM job_posted_date
    ) AS MONTH
FROM job_postings_fact
GROUP BY MONTH
ORDER BY MONTH -- Example  
    CREATE TABLE jan_postings AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 1;
CREATE TABLE Feb_postings AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 2;
CREATE TABLE Mar_postings AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 3;
-- Case Expressions
/* Lable new columns as follows
 - 'Anywhere' jobs as 'remote'
 - 'New York, NY' jobs as 'local'
 - otherwise onsite
 */
SELECT COUNT(job_id) AS schedule_count,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'local'
        ELSE 'Onsite'
    END AS location_schedule
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_schedule;
--Subqueries and Common Table Expressions CTE's
-- 01 job with no degree mentioned 
SELECT company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
        SELECT company_id
        FROM job_postings_fact
        WHERE job_no_degree_mention = True
    ) -- 02 companies with the most job openings
SELECT company_id,
    name AS company_name,
    COUNT(job_id) AS job_count
FROM job_postings_fact jpf
    JOIN company_dim cd USING (company_id)
GROUP BY company_id,
    company_name
ORDER BY job_count DESC;
-- OR --
WITH most_open_jobs AS (
    SELECT company_id,
        job_id
    FROM job_postings_fact
)
SELECT company_id,
    name AS company_name,
    COUNT(job_id) AS job_count
FROM most_open_jobs moj
    JOIN company_dim cd USING(company_id)
GROUP BY company_id,
    company_name
ORDER BY job_count DESC;
--OR--
WITH company_job_count AS (
    SELECT company_id,
        COUNT(*) AS job_count
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT name AS comapany_name,
    job_count
FROM company_dim
    JOIN company_job_count USING(company_id);
-- Find the count of the number of remote job_postings per skill
WITH remote_jobs AS (
    SELECT *
    FROM job_postings_fact
        JOIN skills_job_dim USING(job_id)
    WHERE job_work_from_home = true
        AND job_title_short = 'Data Analyst'
)
SELECT skill_id,
    skills,
    COUNT(job_id) AS job_count
FROM skills_dim sd
    JOIN remote_jobs rj USING(skill_id)
GROUP BY skills,
    skill_id
ORDER BY job_count DESC
LIMIT 5;
-- Find job postings from the first quarter that has salary > $70k
WITH first_quarter_jobs AS (
    SELECT *
    FROM jan_postings
    UNION
    SELECT *
    FROM Feb_postings
    UNION
    SELECT *
    FROM Mar_postings
)
SELECT job_id,
    name AS company_name,
    job_title_short,
    salary_year_avg,
    salary_year_avg > 70000 AS VALID
FROM first_quarter_jobs
    JOIN company_dim USING(company_id)
WHERE salary_year_avg > 70000 is true
    AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC
LIMIT 20;