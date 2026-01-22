# Data Dictionary — Employee Wellness & Productivity Dataset

This document describes the fields in the **employee_wellness** dataset used for the *Employee Wellness & Productivity Analytics* project.

---

## Table Structure Overview

- **Grain (Row Level):** One row per employee
- **Source:** HR master data (Figshare-based synthetic HR dataset) enriched with wellness & productivity fields
- **Primary Key:** `id`

---

## Fields

| # | Column Name         | Data Type        | Description                                                                                         | Example Value                        |
|---|---------------------|------------------|-----------------------------------------------------------------------------------------------------|--------------------------------------|
| 1 | `id`                | String (TEXT)    | Unique employee identifier (primary key).                                                           | `EMP-10001`                          |
| 2 | `first_name`        | String (TEXT)    | Employee’s first name.                                                                              | `Ava`                                |
| 3 | `last_name`         | String (TEXT)    | Employee’s last name.                                                                               | `Singh`                              |
| 4 | `birthdate`         | Date             | Employee’s date of birth. Used to derive age.                                                       | `1989-04-12`                         |
| 5 | `gender`            | String (TEXT)    | Employee’s gender.                                                                                  | `Male`, `Female`                     |
| 6 | `race`              | String (TEXT)    | Self-identified race/ethnicity.                                                                     | `Asian`, `White`                     |
| 7 | `department`        | String (TEXT)    | Functional department of the employee.                                                              | `Engineering`, `HR`, `Sales`         |
| 8 | `jobtitle`          | String (TEXT)    | Job title or role of the employee.                                                                  | `Analyst`, `Manager`, `Engineer`     |
| 9 | `location`          | String (TEXT)    | Work location type or site category. Drives `remote_work`.                                          | `Headquarters`, `Remote`             |
|10 | `hire_date`         | Date             | Date when the employee joined the company. Used to derive tenure.                                   | `2016-09-01`                         |
|11 | `termdate`          | Timestamp (TZ)   | Termination date and time (if the employee has left). `NULL` means still active.                    | `2029-10-29 06:09:38+00` or `NULL`   |
|12 | `location_city`     | String (TEXT)    | City of the primary work location.                                                                  | `Cleveland`, `Austin`                |
|13 | `location_state`    | String (TEXT)    | State/region of the primary work location.                                                          | `Ohio`, `Texas`                      |
|14 | `remote_work`       | String (TEXT)    | Whether the employee primarily works remotely. Derived from `location`.                             | `Yes`, `No`                          |
|15 | `work_hours`        | Numeric (4,2)    | Average working hours per day. Simulated around typical office patterns.                            | `8.50`                               |
|16 | `sleep_hours`       | Numeric (4,2)    | Average sleeping hours per day. Used to model wellness and stress.                                  | `6.75`                               |
|17 | `stress_level`      | Integer (1–10)   | Overall perceived stress level; higher values indicate higher stress.                               | `3`, `7`, `9`                        |
|18 | `job_satisfaction`  | Integer (1–10)   | Self-reported job satisfaction rating; higher values indicate greater satisfaction.                 | `4`, `8`                             |
|19 | `manager_support`   | Integer (1–10)   | Perceived level of support from the employee’s manager.                                             | `2`, `6`, `9`                        |
|20 | `burnout_risk`      | String (TEXT)    | Categorised burnout risk based on stress and sleep patterns.                                        | `Low`, `Medium`, `High`             |
|21 | `productivity_score`| Integer (10–100) | Overall employee productivity/performance score (higher = more productive).                         | `72`, `88`                           |

---

## Derived / Synthetic Logic (High-Level)

These fields are **synthetic / engineered** for analytics:

- `work_hours`  
  - Generated around ~8.5 hours/day with some variation.
  - Bound between **6 and 12 hours**.

- `sleep_hours`  
  - Generated around ~6.5 hours/day with variation.
  - Bound between **4 and 9 hours**.

- `stress_level`  
  - Higher when **work_hours are high** and **sleep_hours are low**.
  - Scaled to an integer from **1 to 10**.

- `job_satisfaction`  
  - Inversely related to `stress_level` with some noise.
  - Scaled to an integer from **1 to 10**.

- `burnout_risk`  
  - Categorised using `stress_level` and `sleep_hours`:
    - `High`  → high stress (≥8) or very low sleep (≤5)
    - `Medium`→ moderate stress (≥6)
    - `Low`   → otherwise

- `manager_support`  
  - Randomised but realistic 1–10 scale, used to understand support’s effect on burnout/productivity.

- `productivity_score`  
  - Influenced by both:
    - **Positive:** job_satisfaction  
    - **Negative:** stress_level  
  - Plus random noise; constrained between **10 and 100**.

---

## Notes for Analysis & Reporting

- You can derive **age** and **tenure** in SQL or Python:
  - Age from `birthdate`
  - Tenure from `hire_date` and `termdate` (or current date)
- Categorical fields useful for grouping:
  - `department`, `location_state`, `remote_work`, `burnout_risk`
- Numeric fields suitable for:
  - Correlations, feature importances, regression/classification:
    - `work_hours`, `sleep_hours`, `stress_level`, `job_satisfaction`, `manager_support`, `productivity_score`

---

## Suggested Usage in Project

- **SQL:** group by `department`, `burnout_risk`, `remote_work` for aggregate insights.
- **Python:** use numeric columns + encoded categoricals to build prediction models.
- **Power BI:** use as the core fact table, with slicers on department, location, burnout_risk, remote_work, etc.