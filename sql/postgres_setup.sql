
-- Employee Wellness & Productivity — PostgreSQL Setup
-- Schema: public

DROP TABLE IF EXISTS employee_wellness CASCADE;
DROP VIEW IF EXISTS vw_employee_enriched;

CREATE TABLE employee_wellness (
    id                 TEXT PRIMARY KEY,
    first_name         TEXT,
    last_name          TEXT,
    birthdate          DATE,
    gender             TEXT,
    race               TEXT,
    department         TEXT,
    jobtitle           TEXT,
    location           TEXT,
    hire_date          DATE,
    termdate           TIMESTAMPTZ,
    location_city      TEXT,
    location_state     TEXT,
    remote_work        TEXT CHECK (remote_work IN ('Yes','No')),
    work_hours         NUMERIC(4,2) CHECK (work_hours BETWEEN 0 AND 24),
    sleep_hours        NUMERIC(4,2) CHECK (sleep_hours BETWEEN 0 AND 24),
    stress_level       INT CHECK (stress_level BETWEEN 1 AND 10),
    job_satisfaction   INT CHECK (job_satisfaction BETWEEN 1 AND 10),
    manager_support    INT CHECK (manager_support BETWEEN 1 AND 10),
    burnout_risk       TEXT CHECK (burnout_risk IN ('Low','Medium','High')),
    productivity_score INT CHECK (productivity_score BETWEEN 0 AND 100)
);

CREATE INDEX idx_emp_dept ON employee_wellness(department);
CREATE INDEX idx_emp_burnout ON employee_wellness(burnout_risk);
CREATE INDEX idx_emp_hiredate ON employee_wellness(hire_date);
CREATE INDEX idx_emp_termdate ON employee_wellness(termdate);

CREATE OR REPLACE VIEW vw_employee_enriched AS
SELECT
    e.*,
    DATE_PART('year', AGE(CURRENT_DATE, e.birthdate))::INT AS age_years,
    CASE
        WHEN e.termdate IS NULL THEN ROUND(EXTRACT(EPOCH FROM (CURRENT_DATE::timestamp - e.hire_date::timestamp))/31557600.0, 2)
        ELSE ROUND(EXTRACT(EPOCH FROM (e.termdate - e.hire_date::timestamp))/31557600.0, 2)
    END AS tenure_years
FROM employee_wellness e;

-- Example analytical queries
-- SELECT department, burnout_risk, COUNT(*) FROM employee_wellness GROUP BY department, burnout_risk;
-- SELECT ROUND(CORR(productivity_score, stress_level)::NUMERIC, 3) FROM employee_wellness;
