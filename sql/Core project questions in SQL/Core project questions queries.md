**3.1 Burnout risk by department**

SELECT

  department,

  burnout\_risk,

  COUNT(\*) AS employees

FROM employee\_wellness

GROUP BY department, burnout\_risk

ORDER BY department, burnout\_risk;



**3.2 Average productivity by stress level**

SELECT

  stress\_level,

  ROUND(AVG(productivity\_score), 2) AS avg\_productivity,

  COUNT(\*) AS employees

FROM employee\_wellness

GROUP BY stress\_level

ORDER BY stress\_level;



**3.3 Sleep vs productivity (via sleep bands)**

SELECT

  CASE

    WHEN sleep\_hours < 5 THEN '<5 hrs'

    WHEN sleep\_hours BETWEEN 5 AND 6 THEN '5–6 hrs'

    WHEN sleep\_hours BETWEEN 6 AND 7 THEN '6–7 hrs'

    WHEN sleep\_hours BETWEEN 7 AND 8 THEN '7–8 hrs'

    ELSE '>8 hrs'

  END AS sleep\_band,

  ROUND(AVG(productivity\_score), 2) AS avg\_productivity,

  ROUND(AVG(stress\_level), 2)       AS avg\_stress,

  COUNT(\*) AS employees

FROM employee\_wellness

GROUP BY sleep\_band

ORDER BY sleep\_band;



**3.4 Remote vs on-site: stress \& productivity**

SELECT

  remote\_work,

  ROUND(AVG(stress\_level), 2)       AS avg\_stress,

  ROUND(AVG(job\_satisfaction), 2)   AS avg\_satisfaction,

  ROUND(AVG(productivity\_score), 2) AS avg\_productivity,

  COUNT(\*) AS employees

FROM employee\_wellness

GROUP BY remote\_work;



**3.5 Manager support vs burnout**

SELECT

  CASE

    WHEN manager\_support BETWEEN 1 AND 3 THEN 'Low (1–3)'

    WHEN manager\_support BETWEEN 4 AND 7 THEN 'Medium (4–7)'

    ELSE 'High (8–10)'

  END AS manager\_support\_band,

  burnout\_risk,

  COUNT(\*) AS employees

FROM employee\_wellness

GROUP BY manager\_support\_band, burnout\_risk

ORDER BY manager\_support\_band, burnout\_risk;



**3.6 Tenure vs burnout (using the view)**

SELECT

  CASE

    WHEN tenure\_years < 1 THEN '<1 year'

    WHEN tenure\_years < 3 THEN '1–3 years'

    WHEN tenure\_years < 5 THEN '3–5 years'

    WHEN tenure\_years < 10 THEN '5–10 years'

    ELSE '10+ years'

  END AS tenure\_band,

  burnout\_risk,

  COUNT(\*) AS employees

FROM vw\_employee\_enriched

GROUP BY tenure\_band, burnout\_risk

ORDER BY tenure\_band, burnout\_risk;



**3.7 Correlation-like view (quick stats)**

SELECT

  ROUND(CORR(productivity\_score, stress\_level)::NUMERIC, 3)       AS corr\_prod\_stress,

  ROUND(CORR(productivity\_score, job\_satisfaction)::NUMERIC, 3)   AS corr\_prod\_satisfaction,

  ROUND(CORR(productivity\_score, manager\_support)::NUMERIC, 3)    AS corr\_prod\_manager,

  ROUND(CORR(productivity\_score, work\_hours)::NUMERIC, 3)         AS corr\_prod\_workhours,

  ROUND(CORR(productivity\_score, sleep\_hours)::NUMERIC, 3)        AS corr\_prod\_sleephours

FROM employee\_wellness;

