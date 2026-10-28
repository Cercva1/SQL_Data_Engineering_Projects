/*
Question: What are the most optimal skills for data engineers-balancing both demand and salary?
• Create a ranking column that combines demand count and median salary to identify the most valuable skills.
• Focus only on remote Data Engineer positions with specified annual salaries.
• Why?
• This approach highlights skills that balance market demand and financial reward.
    It weights core skills appropriately, rather than letting rare, outlier skills distort the results. 
*/

SELECT  
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    -- count(jpf.*) as demand_count,
    round(ln(count(jpf.*)), 1) AS ln_demand_count,
    round((MEDIAN(jpf.salary_year_avg) * ln(count(jpf.*))/1_000_000), 2) as opptimal_score 
FROM 
    job_postings_fact as jpf
INNER JOIN skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
    on sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = true
    And jpf.salary_year_avg is not null
GROUP BY 
    sd.skills
HAVING 
    count(jpf.*) > 100
ORDER BY
    opptimal_score DESC
LIMIT 25;

/*

CODE EXPLANATION in KEY TAKEWAYS:

Star schema joins. A fact table (job_postings_fact) links through a bridge table (skills_job_dim) to a dimension table (skills_dim). That is the standard way to handle many-to-many relationships, since one job has many skills.

WHERE vs HAVING. WHERE filters rows before grouping (role, remote, salary not null). HAVING filters groups after aggregation (count > 100).

MEDIAN instead of AVG. The median is robust to salary outliers.

Filter out NULLs before aggregating. salary_year_avg IS NOT NULL ensures the counts only include postings that actually have salary data.

Minimum sample size. HAVING count > 100 removes skills with too few postings to trust.

Log transform. ln(count) compresses a skewed variable so it doesn’t dominate the score.

Composite metric. Combining two measures (salary × ln(demand)) into one score lets you rank on a trade-off rather than a single column.

Scaling for readability. Dividing by 1,000,000 doesn’t change the ranking, only how easy the number is to read.

Ordering by an alias. ORDER BY opptimal_score works because ORDER BY runs after SELECT, unlike WHERE.

DuckDB conveniences. 1_000_000 uses underscores as digit separators, and MEDIAN() is a built-in function. Postgres would need PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ...) instead.


TOP Skills by Optimal SCORE:
    Python, SQL and AWS are the base. They have the highest demand but average pay, so they get you hired rather than paid more.
    Airflow and Spark are the core data engineering stack. They offer strong demand and pay of about $140–150K.
    Terraform is the best differentiator. It has the top score with moderate demand and pays about $50K more than SQL.
    Infrastructure skills pay a premium. Terraform, Kubernetes and Kafka sit at about $145–184K, so data engineers who also handle infrastructure earn more.
    AWS leads the clouds. It ranks above Azure and GCP on both score and pay.
    Lower-ranked skills are nearly interchangeable. Most of the bottom half sits around $135K, so picking among them matters little.
    our learning path: SQL and Python, then AWS, then Airflow and Spark, then Terraform and Kafka.
────────────┬───────────────┬─────────────────┬────────────────┐
│   skills   │ median_salary │ ln_demand_count │ opptimal_score │
│  varchar   │    double     │     double      │     double     │
├────────────┼───────────────┼─────────────────┼────────────────┤
│ terraform  │      184000.0 │             5.3 │           0.97 │
│ python     │      135000.0 │             7.0 │           0.95 │
│ aws        │      137320.0 │             6.7 │           0.91 │
│ sql        │      130000.0 │             7.0 │           0.91 │
│ airflow    │      150000.0 │             6.0 │           0.89 │
│ spark      │      140000.0 │             6.2 │           0.87 │
│ snowflake  │      135500.0 │             6.1 │           0.82 │
│ kafka      │      145000.0 │             5.7 │           0.82 │
│ azure      │      128000.0 │             6.2 │           0.79 │
│ java       │      135000.0 │             5.7 │           0.77 │
│ scala      │      137290.0 │             5.5 │           0.76 │
│ git        │      140000.0 │             5.3 │           0.75 │
│ kubernetes │      150500.0 │             5.0 │           0.75 │
│ databricks │      132750.0 │             5.6 │           0.74 │
│ redshift   │      130000.0 │             5.6 │           0.73 │
│ gcp        │      136000.0 │             5.3 │           0.72 │
│ nosql      │      134415.0 │             5.3 │           0.71 │
│ hadoop     │      135000.0 │             5.3 │           0.71 │
│ pyspark    │      140000.0 │             5.0 │            0.7 │
│ mongodb    │      135750.0 │             4.9 │           0.67 │
│ docker     │      135000.0 │             5.0 │           0.67 │
│ r          │      134775.0 │             4.9 │           0.66 │
│ go         │      140000.0 │             4.7 │           0.66 │
│ bigquery   │      135000.0 │             4.8 │           0.65 │
│ github     │      135000.0 │             4.8 │           0.65 │
├────────────┴───────────────┴─────────────────┴────────────────┤
│ 25 rows                                             4 columns │
└───────────────────────────────────────────────────────────────┘

*/