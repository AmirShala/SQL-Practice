"""
A curated collection of SQL interview questions from StrataScratch.com,
covering a wide range of difficulty levels—from basic queries to advanced analytical challenges—designed to strengthen problem-solving and real-world data skills. 
  


Q: Users By Average Session Time
Calculate each user's average session time, where a session is defined as the time difference between a page_load and a page_exit.
  Assume each user has only one session per day. If there are multiple page_load or page_exit events on the same day, use only the latest page_load and the earliest page_exit.
  Only consider sessions where the page_load occurs before the page_exit on the same day. Output the user_id and their average session time.

Table
facebook_web_log
action: varchar
timestamp: datetime2
user_id: bigint


Solution:

WITH loads AS (
  SELECT
    user_id,
    CAST(timestamp AS DATE) AS day,
    MAX(timestamp) AS load_time
  FROM facebook_web_log
  WHERE action = 'page_load'
  GROUP BY user_id, CAST(timestamp AS DATE)
),
exits AS (
  SELECT
    user_id,
    CAST(timestamp AS DATE) AS day,
    MIN(timestamp) AS exit_time
  FROM facebook_web_log
  WHERE action = 'page_exit'
  GROUP BY user_id, CAST(timestamp AS DATE)
),
sessions AS (
  SELECT
    l.user_id,
    l.load_time,
    e.exit_time,
    DATEDIFF(SECOND, l.load_time, e.exit_time) AS session_duration
  FROM loads l
  JOIN exits e
    ON l.user_id = e.user_id AND l.day = e.day
  WHERE l.load_time < e.exit_time
)
SELECT
  user_id,
  AVG(session_duration * 1.0) AS avg_session_duration
FROM sessions
GROUP BY user_id;

==================================================================================================================

  Question: Finding Updated Records

We have a table with employees and their salaries; however, some of the records are old and contain outdated salary information.
  Since there is no timestamp, assume salary is non-decreasing over time.
  You can consider the current salary for an employee is the largest salary value among their records.
  If multiple records share the same maximum salary, return any one of them. Output their id, first name,
  last name, department ID, and current salary. Order your list by employee ID in ascending order.

Table- 
  
ms_employee_salary
department_id:bigint
first_name:varchar
id:bigint
last_name:varchar
salary:bigint

  Solution:

  SELECT id,
       first_name,
       last_name,
       department_id,
       salary
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY id ORDER BY salary DESC, department_id DESC) AS rn
  FROM ms_employee_salary
) s
WHERE rn = 1
ORDER BY id ASC;

==================================================================================================================

Question: Total Cost Of Orders

Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost.
Order records by customer's first name alphabetically.

Tables-
  
customers
address:varchar
city:varchar
first_name:varchar
id:bigint
last_name:varchar
phone_number:varchar

orders
cust_id:bigint
id:bigint
order_date:date
order_details:varchar
total_order_cost:bigint


  Solution:

  SELECT customers.id,
       customers.first_name,
       SUM(total_order_cost) AS total_cost
FROM orders
JOIN customers ON customers.id = orders.cust_id
GROUP BY customers.id,
         customers.first_name
ORDER BY customers.first_name ASC;

==================================================================================================================

Question:

Acceptance Rate By Date

Calculate the friend acceptance rate for each date when friend requests were sent.
  A request is sent if action = sent and accepted if action = accepted.
  If a request is not accepted, there is no record of it being accepted in the table.
The output will only include dates where requests were sent and at least one of them was accepted (acceptance can occur on any date after the request is sent).

Table
fb_friend_requests
action:varchar
date:date
user_id_receiver:varchar
user_id_sender:varchar

  Solution:
WITH sent_cte AS
  (SELECT date, user_id_sender,
                user_id_receiver
   FROM fb_friend_requests
   WHERE action='sent' ),
     accepted_cte AS
  (SELECT date, user_id_sender,
                user_id_receiver
   FROM fb_friend_requests
   WHERE action='accepted' )
SELECT a.date,
       count(b.user_id_receiver)/CAST(count(a.user_id_sender) AS decimal) AS percentage_acceptance
FROM sent_cte a
LEFT JOIN accepted_cte b ON a.user_id_sender=b.user_id_sender
AND a.user_id_receiver=b.user_id_receiver
GROUP BY a.date
  
==================================================================================================================

  Question:  Acceptance Rate By Date

Calculate the friend acceptance rate for each date when friend requests were sent.
  A request is sent if action = sent and accepted if action = accepted.
  If a request is not accepted, there is no record of it being accepted in the table.
The output will only include dates where requests were sent and at least one of them was accepted (acceptance can occur on any date after the request is sent).

Table
fb_friend_requests
action:varchar
date:date
user_id_receiver:varchar
user_id_sender:varchar

  Solution:

  WITH daily AS (
  SELECT DISTINCT user_id, CAST(created_at AS date) AS purchase_date
  FROM amazon_transactions
),
ranked AS (
  SELECT
    user_id,
    purchase_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY purchase_date) AS rn
  FROM daily
),
first_two AS (
  SELECT
    user_id,
    MAX(CASE WHEN rn = 1 THEN purchase_date END) AS first_date,
    MAX(CASE WHEN rn = 2 THEN purchase_date END) AS second_date
  FROM ranked
  WHERE rn <= 2
  GROUP BY user_id
)
SELECT user_id
FROM first_two
WHERE second_date IS NOT NULL
  AND DATEDIFF(day, first_date, second_date) BETWEEN 1 AND 7
ORDER BY user_id;
  
==================================================================================================================

  Question:Risky Projects

You are given a set of projects and employee data. Each project has a name, a budget, and a specific duration,
while each employee has an annual salary and may be assigned to one or more projects for particular periods.
The task is to identify which projects are overbudget. A project is considered overbudget if the prorated cost of all employees assigned to it exceeds the project’s budget.
To solve this, you must prorate each employee's annual salary based on the exact period they work on a given project, relative to a full year.
For example, if an employee works on a six-month project, only half of their annual salary should be attributed to that project. 
Sum these prorated salary amounts for all employees assigned to a project and compare the total with the project’s budget.
Your output should be a list of overbudget projects, where each entry includes the project’s name, its budget,
and the total prorated employee expenses for that project. The total expenses should be rounded up to the nearest dollar.
Assume all years have 365 days and disregard leap years.

Tables
linkedin_projects
budget:bigint
end_date:date
id:bigint
start_date:date
title:varchar
  
linkedin_emp_projects
emp_id:bigint
project_id:bigint
  
linkedin_employees
first_name:varchar
id:bigint
last_name:varchar
salary:bigint



  Solution:

  WITH ActualBudget AS (
    SELECT 
        LP.Id,
        ROUND(
            SUM((DATEDIFF(DAY, LP.Start_Date, LP.End_Date) * 1.0 / 365) * LE.Salary),
            0
        ) AS ActualBudget
    FROM LinkedIn_Projects LP
    JOIN LinkedIn_Emp_Projects LEP ON LP.Id = LEP.Project_Id
    JOIN LinkedIn_Employees LE ON LEP.Emp_Id = LE.Id
    GROUP BY LP.Id
)
SELECT 
    LP.Title,
    LP.Budget,
    AB.ActualBudget
FROM LinkedIn_Projects LP
JOIN ActualBudget AB ON AB.Id = LP.Id
WHERE LP.Budget < AB.ActualBudget;
  
==================================================================================================================

Question: Finding Purchases

Identify returning active users by finding users who made a repeat purchase within 7 days or less of their previous transaction, excluding same-day purchases. Output a list of these user_id.

Table
amazon_transactions
created_at:date
id:bigint
item:varchar
revenue:bigint
user_id:bigint

Solution:

  WITH ordered_tx AS
    (SELECT user_id,
            CAST(created_at AS DATE) AS tx_date,
            LAG(CAST(created_at AS DATE)) OVER (PARTITION BY user_id
                                                ORDER BY created_at) AS prev_tx_date
     FROM amazon_transactions)
SELECT DISTINCT user_id
FROM ordered_tx
WHERE prev_tx_date IS NOT NULL
    AND DATEDIFF(DAY, prev_tx_date, tx_date) > 0
    AND DATEDIFF(DAY, prev_tx_date, tx_date) <= 7;

==================================================================================================================

  
==================================================================================================================
==================================================================================================================
==================================================================================================================
==================================================================================================================
==================================================================================================================
==================================================================================================================
==================================================================================================================
  
















  
"""
