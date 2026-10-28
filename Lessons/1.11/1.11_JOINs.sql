SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
FROM 
    job_postings_fact as jpf
LEft JOIN company_dim as cd
    ON jpf.company_id = cd.company_id;

SELECT count(company_id)
from company_dim;

SELECT * 
FROM skills_dim
limit 10;

SELECT *
FROM skills_job_dim
limit 10;

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM  
    job_postings_fact as jpf
LEFT JOIN skills_job_dim as sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id;

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM  
    job_postings_fact as jpf
INNER JOIN skills_job_dim as sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id;