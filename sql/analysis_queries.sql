-- Employee Wellness & Productivity Analytics
-- Analysis Queries (PostgreSQL)
-- Make sure you are connected to the "wellness" database.


-- 1) Basic sanity checks
SELECT COUNT(*) AS total_rows FROM employee_wellness;

SELECT burnout_risk, COUNT(*) AS employees
FROM employee_wellness
GROUP BY burnout_risk
ORDER BY burnout_risk;

SELECT department, COUNT(*) AS employees
FROM employee_wellness
GROUP BY department
ORDER BY employees DESC;


-- 2) Burnout risk by department
SELECT
  department,
  burnout_risk,
  COUNT(*) AS employees
FROM employee_wellness
GROUP BY department, burnout_risk
ORDER BY department, burnout_risk;


-- 3) Average productivity by stress level
SELECT
  stress_level,
  ROUND(AVG(productivity_score), 2) AS avg_productivity,
  COUNT(*) AS employees
FROM employee_wellness
GROUP BY stress_level
ORDER BY stress_level;


-- 4) Sleep vs productivity (sleep bands)
SELECT
  CASE
    WHEN sleep_hours < 5 THEN '<5 hours'
    WHEN sleep_hours BETWEEN 5 AND 6 THEN '5–6 hours'
    WHEN sleep_hours BETWEEN 6 AND 7 THEN '6–7 hours'
    WHEN sleep_hours BETWEEN 7 AND 8 THEN '7–8 hours'
    ELSE '>8 hours'
  END AS sleep_band,
  ROUND(AVG(productivity_score), 2) AS avg_productivity,
  ROUND(AVG(stress_level), 2) AS avg_stress,
  COUNT(*) AS employees
FROM employee_wellness
GROUP BY sleep_band
ORDER BY sleep_band;


-- 5) Remote vs On-site: stress, satisfaction, productivity
SELECT
  remote_work,
  ROUND(AVG(stress_level), 2)       AS avg_stress,
  ROUND(AVG(job_satisfaction), 2)   AS avg_satisfaction,
  ROUND(AVG(productivity_score), 2) AS avg_productivity,
  COUNT(*) AS employees
FROM employee_wellness
GROUP BY remote_work
ORDER BY remote_work;


-- 6) Manager support vs burnout risk
SELECT
  CASE
    WHEN manager_support BETWEEN 1 AND 3 THEN 'Low (1–3)'
    WHEN manager_support BETWEEN 4 AND 7 THEN 'Medium (4–7)'
    ELSE 'High (8–10)'
  END AS manager_support_band,
  burnout_risk,
  COUNT(*) AS employees
FROM employee_wellness
GROUP BY manager_support_band, burnout_risk
ORDER BY manager_support_band, burnout_risk;


-- 7) Age & tenure view (make sure vw_employee_enriched exists)
-- Create view if not created yet:
-- CREATE OR REPLACE VIEW vw_employee_enriched AS
-- SELECT
--   e.*,
--   DATE_PART('year', AGE(CURRENT_DATE, e.birthdate))::INT AS age_years,
--   CASE
--     WHEN e.termdate IS NULL
--       THEN ROUND(EXTRACT(EPOCH FROM (CURRENT_DATE::timestamp - e.hire_date::timestamp))/31557600.0, 2)
--     ELSE ROUND(EXTRACT(EPOCH FROM (e.termdate - e.hire_date::timestamp))/31557600.0, 2)
--   END AS tenure_years
-- FROM employee_wellness e;

-- 7.1) Tenure vs burnout
SELECT
  CASE
    WHEN tenure_years < 1 THEN '<1 year'
    WHEN tenure_years < 3 THEN '1–3 years'
    WHEN tenure_years < 5 THEN '3–5 years'
    WHEN tenure_years < 10 THEN '5–10 years'
    ELSE '10+ years'
  END AS tenure_band,
  burnout_risk,
  COUNT(*) AS employees
FROM vw_employee_enriched
GROUP BY tenure_band, burnout_risk
ORDER BY tenure_band, burnout_risk;


-- 8) Correlations (approximate, numeric only)
SELECT
  ROUND(CORR(productivity_score, stress_level)::NUMERIC, 3)       AS corr_prod_stress,
  ROUND(CORR(productivity_score, job_satisfaction)::NUMERIC, 3)   AS corr_prod_satisfaction,
  ROUND(CORR(productivity_score, manager_support)::NUMERIC, 3)    AS corr_prod_manager,
  ROUND(CORR(productivity_score, work_hours)::NUMERIC, 3)         AS corr_prod_workhours,
  ROUND(CORR(productivity_score, sleep_hours)::NUMERIC, 3)        AS corr_prod_sleephours
FROM employee_wellness;


-- 9) High-risk employees (for a hypothetical HR action list)
SELECT
  id,
  first_name,
  last_name,
  department,
  stress_level,
  sleep_hours,
  job_satisfaction,
  manager_support,
  burnout_risk,
  productivity_score
FROM employee_wellness
WHERE burnout_risk = 'High'
ORDER BY productivity_score ASC, stress_level DESC
LIMIT 50;