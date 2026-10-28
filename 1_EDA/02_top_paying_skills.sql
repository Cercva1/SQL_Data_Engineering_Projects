/*
Question: What are the highest-paying skills for data engineers?
• Calculate the median salary for each skill required in data engineer positions
• Focus on remote positions with specified salaries
• Include skill frequency to identify both salary and demand
• Why? Helps identify which skills command the highest compensation while also showing how common those skills are, 
        providing a more complete picture for skill development priorities.
        The median is used instead of the average to reduce the impact of outlier salaries.
*/

SELECT  
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    count(jpf.*) as demand_count
FROM 
    job_postings_fact as jpf
INNER JOIN skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
    on sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = true
GROUP BY 
    sd.skills
HAVING 
    count(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25;

/*
Key Insights:
Pay and demand don’t line up. The highest-paid skills are niche. Rust has 232 postings, Neo4j 277 and FastAPI 204. The ones with real volume sit at about $150K: Airflow (9,996), Kubernetes (4,202) and Terraform (3,248).
Terraform is the standout. It ties for #2 on pay ($184K) and is #3 on demand, the best combination in the list.
Infra and DevOps dominate. Terraform, Kubernetes, Ansible, VMware and Airflow are all well represented. 
    Orchestration and infrastructure-as-code skills pay well and are widely needed.
Airflow is the volume king. It has more than twice the demand of any other skill. For data engineering, it’s the safest skill to have.
Backend languages beat frontend. Rust and Go top the list, while CSS and TypeScript sit near $150K.
Some results look noisy. Zoom (127 postings) and GDPR at around $168K probably reflect senior or compliance-heavy roles rather than the skill itself, 
    so treat skills with small counts cautiously.
The ceiling is compressed. Ranks 11–25 fall in a narrow band of about $147K–$155K, so most skills pay similarly. 
    The premium comes from rare skills or combinations, such as Airflow with Terraform and Kubernetes.
┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ golang     │      184000.0 │          912 │
│ terraform  │      184000.0 │         3248 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ django     │      155000.0 │          265 │
│ bitbucket  │      155000.0 │          478 │
│ crystal    │      154224.0 │          129 │
│ atlassian  │      151500.0 │          249 │
│ c          │      151500.0 │          444 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ node       │      150000.0 │          179 │
│ ruby       │      150000.0 │          736 │
│ css        │      150000.0 │          262 │
│ airflow    │      150000.0 │         9996 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
├────────────┴───────────────┴──────────────┤
│ 25 rows                         3 columns │
└───────────────────────────────────────────┘
*/