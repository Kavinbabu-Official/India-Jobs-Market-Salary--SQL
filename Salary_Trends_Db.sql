CREATE TABLE insight (
job_id INT PRIMARY KEY,
job_title VARCHAR(50),
company_name VARCHAR(50),
location VARCHAR(50),
experience_required_years INT,
skills VARCHAR(100),
salary_min_inr DECIMAL(10,2),
salary_max_inr DECIMAL(10,2),
employment_type VARCHAR(50),
remote_option VARCHAR(50)
);

-- What is the total number of job listings available in the dataset?
SELECT 
	COUNT(*)
FROM
	insight

-- How many job listings contain missing values in critical fields?
SELECT
	COUNT(*) AS incomplete_records
FROM insight i 
WHERE 
	i.job_id IS NULL OR
	i.job_title IS NULL OR
	i.company_name IS NULL OR
	i.location IS NULL OR
	i.experience_required_years IS NULL OR
	i.skills IS NULL OR
	i.salary_min_inr IS NULL OR
	i.salary_max_inr IS NULL OR
	i.employment_type IS NULL OR
	i.remote_option IS NULL

-- Retrieve the top 50 job listings requiring more than 3 years of experience?
SELECT 
	i.job_id,
	i.job_title,
	i.company_name,
	i.location,
	i.experience_required_years,
	i.salary_max_inr
FROM insight i
WHERE
	i.experience_required_years > 3
ORDER BY
	i.experience_required_years 
	DESC,
	i.job_id ASC
LIMIT 50

-- What is the salary range (minimum to maximum) for each job title?
SELECT
	i.job_title,
	MIN(i.salary_min_inr) AS minimum_salary,
	MAX(i.salary_max_inr) AS maximum_salary
FROM
	insight i
GROUP BY
	i.job_title
ORDER BY 
	maximum_salary
	DESC


-- For each job title, which company offers the highest salary?
SELECT 
	job_title,
	company_name,
	location,
	salary_max_inr
FROM (
SELECT
	i.job_title,
	i.company_name,
	i.location,
	i.salary_max_inr,
ROW_NUMBER() OVER(
	PARTITION BY i.job_title 
	ORDER BY i.salary_max_inr DESC
) AS jobs_rank
FROM
	insight i
) t 
WHERE 
	jobs_rank = 1
	