/*
Find the top 10 companies for posting jobs
They must have >3000 postings
LIMIT this to only US jobs
*/
EXPLAIN ANALYZE
SELECT 
    cd.name AS Company_Name,
    count(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf
    LEFT JOIN company_dim as cd 
        on jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING count(jpf.job_id) > 3000
ORder BY posting_count DESC
LIMIT 10;

EXPLAIN SELECT * from job_postings_fact;



