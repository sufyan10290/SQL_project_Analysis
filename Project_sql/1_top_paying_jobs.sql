/*QUESTION: What are the top paying Data_Analyst_jobs?
 -Identify the top 10 Data Analyst roles that are available Remotely
 -Focus on job postings with specifoed salaries(remove nulls).
 -Why? Highlights the top-paying roles for Data Analyst, offering insight into 
 */
SELECT job_id,
    name AS company_name,
    job_title_short,
    salary_year_avg,
    job_location,
    job_schedule_type
FROM job_postings_fact jpf
    JOIN company_dim cd USING (company_id)
WHERE job_work_from_home = TRUE
    AND job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;