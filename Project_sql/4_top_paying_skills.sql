--QUESTION: What are the top paying skills for Data Analyst?
SELECT skills,
    ROUND(AVG(salary_year_avg), 0) AS skill_avg_salary
FROM job_postings_fact jpf
    JOIN skills_job_dim USING(job_id)
    JOIN skills_dim USING(skill_id)
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL --job_work_from_home = TRUE
GROUP BY skills
ORDER BY skill_avg_salary DESC
LIMIT 10;