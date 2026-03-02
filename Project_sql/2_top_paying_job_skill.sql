/* QUESTION: What skills are required for the top-paying Data Analyst jobs?
 - Use the to 10 highest-paying Data Analyst jobs from the first query
 - Add the specific skills required for these roles
 - Why? It provides a detailed look at which high-paying jobs demand certain skills,
 helping job seekers to understand which skills to develop that align with top salaries.
 */
WITH top_paying_jobs AS(
    SELECT job_id,
        job_title_short,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact jpf
        JOIN company_dim cd USING (company_id)
    WHERE job_work_from_home = TRUE
        AND job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT tpj.*,
    sd.skills
FROM top_paying_jobs tpj
    JOIN skills_job_dim sjd USING(job_id)
    JOIN skills_dim sd USING(skill_id)