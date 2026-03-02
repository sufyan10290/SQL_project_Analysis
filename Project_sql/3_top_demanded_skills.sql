--QUESTION: What are the most in-demand skills for Data Analyst?
SELECT skill_id,
    skills,
    COUNT(skill_id) AS skill_count
FROM job_postings_fact jpf
    JOIN skills_job_dim USING(job_id)
    JOIN skills_dim USING(skill_id)
WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY skill_id,
    skills
ORDER BY skill_count DESC
LIMIT 10;