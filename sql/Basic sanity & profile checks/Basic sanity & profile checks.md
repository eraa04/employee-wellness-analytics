**2.1 Row count \& a quick peek**

SELECT COUNT(\*) AS total\_rows

FROM employee\_wellness;



SELECT \*

FROM employee\_wellness

LIMIT 10;



**2.3 Distribution of burnout risk**

SELECT burnout\_risk, COUNT(\*) AS employees

FROM employee\_wellness

GROUP BY burnout\_risk

ORDER BY burnout\_risk;



**2.4 Distribution by department**

SELECT department, COUNT(\*) AS employees

FROM employee\_wellness

GROUP BY department

ORDER BY employees DESC;



