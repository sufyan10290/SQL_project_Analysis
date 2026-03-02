--QUESTION: What are the most optimal skills to learn? (high-demand, high-paying)
SELECT skills,
    COUNT(skill_id) AS skill_count,
    ROUND(AVG(salary_year_avg), 0) AS skill_avg_salary
FROM job_postings_fact jpf
    JOIN skills_job_dim USING(job_id)
    JOIN skills_dim USING(skill_id)
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY skills
HAVING COUNT(skill_id) > 10 --ROUND(AVG(salary_year_avg), 0) > 100000
ORDER BY skill_count DESC,
    skill_avg_salary DESC
LIMIT 25;