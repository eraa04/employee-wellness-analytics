# Employee Wellness & Productivity Analytics

## Project Overview

This project is an **end-to-end HR analytics case study** that analyzes employee wellness, burnout risk, and productivity using **SQL, Python, and Power BI**.

The goal is to help HR and leadership teams understand **what drives burnout and performance**, so they can take **data-driven actions** instead of generic wellness initiatives.

---

## Business Problem

Organizations struggle to identify:

* Which employees are at risk of burnout
* Which departments are under high stress
* How sleep, stress, and manager support impact productivity

This project answers those questions using data analysis and visualization.

---

## Tools & Technologies Used

| Tool                                                   | Usage                                                  |
| ------------------------------------------------------ | ------------------------------------------------------ |
| **PostgreSQL (SQL)**                                   | Data storage, cleaning, transformations, aggregations  |
| **Python (Pandas, Matplotlib, Seaborn, Scikit-learn)** | EDA, feature engineering, visualization, preprocessing |
| **Power BI**                                           | Interactive dashboards and business storytelling       |
| **Excel / CSV**                                        | Data exchange between tools                            |

---

## Project Structure

```
employee_wellness_project/
│
├── data_raw/                 # Original cleaned dataset
├── data_processed/           # Python-processed dataset for Power BI
├── sql/                      # SQL DDL, views, queries
├── python/                   # Python analysis scripts
├── visuals/                  # Saved charts from Python
├── documentation/            # Data dictionary & notes
└── powerbi/                  # Power BI dashboard (.pbix)
```

---

## Dataset Description

* Source: Public HR dataset (Figshare) enhanced with wellness & productivity fields
* Grain: One row per employee
* Size: ~5000 employee records

Key fields include:

* Stress level (1–10)
* Sleep hours
* Job satisfaction
* Manager support
* Burnout risk (Low / Medium / High)
* Productivity score

---

## Analysis Workflow

### 1️) SQL Phase (PostgreSQL)

* Created staging and final tables
* Cleaned data types and null values
* Built analytical views for burnout, stress, and productivity
* Generated department-level aggregates

### 2️) Python Phase

* Exploratory Data Analysis (EDA)
* Feature engineering (Sleep Bands)
* Visual analysis (stress vs productivity)
* Processed final dataset for Power BI

### 3️) Power BI Phase

Built a **5-page interactive dashboard**:

1. **Wellness Overview** – KPIs & burnout distribution
2. **Burnout Risk Analysis** – Department, gender, work mode
3. **Stress vs Productivity** – Relationship analysis
4. **Manager Impact** – Leadership effect on performance
5. **Department Comparison** – Team-level insights

---

## Key Insights

* Higher stress levels are strongly associated with lower productivity
* Employees sleeping 7–8 hours show the highest productivity
* Low manager support correlates with high burnout risk
* Burnout risk varies significantly across departments
* Targeted interventions are more effective than generic programs

---

## Dashboard Preview

*(Add screenshots of Power BI dashboard here)*

---

## Business Value

This dashboard enables HR and leadership to:

* Identify high-risk employees early
* Focus wellness programs where they matter most
* Improve productivity through better management practices
* Make data-driven HR decisions

---

## Future Improvements

* Add time-based trends (monthly burnout tracking)
* Integrate employee survey data
* Deploy dashboard to Power BI Service
* Automate data refresh

---

## Learnings

* Built confidence in end-to-end data projects
* Learned how to translate analysis into business insights
* Strengthened SQL, Python, and Power BI integration
* Improved data storytelling skills

---

## Author

**Era**
Senior Data Analyst | SQL | Python | Power BI

---

## 📬 Contact

If you’d like to discuss this project or collaborate:

* LinkedIn: www.linkedin.com/in/era-1010141b2
* GitHub: https://github.com/eraa04

---

⭐ If you found this project useful, feel free to star the repository!
