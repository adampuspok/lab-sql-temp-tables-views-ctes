USE sakila;

-- TASK 1 
CREATE VIEW customer_rental_summary AS
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

SELECT * FROM customer_rental_summary ORDER BY rental_count DESC;

-- TASK 2

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT
  crs.customer_id,
  crs.first_name,
  crs.last_name,
  crs.email,
  crs.rental_count,
  ROUND(SUM(p.amount), 2) AS total_paid
FROM customer_rental_summary crs
LEFT JOIN payment p ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id, crs.first_name, crs.last_name, crs.email, crs.rental_count;

SELECT * FROM customer_payment_summary ORDER BY total_paid DESC;

-- TASK 3

WITH customer_summary_cte AS (
  SELECT
    cps.customer_id,
    cps.first_name,
    cps.last_name,
    cps.email,
    cps.rental_count,
    cps.total_paid
  FROM customer_payment_summary cps
)

SELECT *
FROM customer_summary_cte
ORDER BY total_paid DESC;

-- Final querry using CTE

WITH customer_summary_cte AS (
  SELECT
    cps.customer_id,
    cps.first_name,
    cps.last_name,
    cps.email,
    cps.rental_count,
    cps.total_paid
  FROM customer_payment_summary cps
)

SELECT
  CONCAT(first_name, ' ', last_name) AS customer_name,
  email,
  rental_count,
  total_paid,
  ROUND(
    CASE 
      WHEN rental_count > 0 THEN total_paid / rental_count
      ELSE 0
    END, 2
  ) AS average_payment_per_rental
FROM customer_summary_cte
ORDER BY total_paid DESC;
