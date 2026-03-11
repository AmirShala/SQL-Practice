--Crack SQL Interview in 50 Qs

--EASY questions

/*Q1: Find Customer Referee
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+
In SQL, id is the primary key column for this table.
Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.
 

Find the names of the customer that are either:

referred by any customer with id != 2.
not referred by any customer.

Solution:

SELECT 
    c.name
FROM Customer c
WHERE 
    c.referee_id <> 2
    OR c.referee_id IS NULL

=================================================================================================================================

Q2: Big Countries
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
| area        | int     |
| population  | int     |
| gdp         | bigint  |
+-------------+---------+

A country is big if:

it has an area of at least three million (i.e., 3000000 km2), or
it has a population of at least twenty-five million (i.e., 25000000).
Write a solution to find the name, population, and area of the big countries.

Solution:

SELECT 
    w.name,
    w.population,
    w.area
FROM World w
WHERE 
    w.area >= 3000000
    OR w.population >= 25000000

=================================================================================================================================

Q3: Article Views I
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
There is no primary key (column with unique values) for this table, the table may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.
 

Write a solution to find all the authors that viewed at least one of their own articles.

Return the result table sorted by id in ascending order.

Solution:

SELECT DISTINCT 
    v.author_id AS id
FROM Views v
WHERE v.author_id = v.viewer_id
ORDER BY id

=================================================================================================================================

Q4: Invalid Tweets
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
tweet_id is the primary key (column with unique values) for this table.
content consists of alphanumeric characters, '!', or ' ' and no other special characters.
This table contains all the tweets in a social media app.
 

Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

Solution:

SELECT 
    t.tweet_id
FROM Tweets t
WHERE LEN(t.content) > 15

=================================================================================================================================

Q5: Replace Employee ID With The Unique Identifier

Table: Employees
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains the id and the name of an employee in a company.

Table: EmployeeUNI

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| unique_id     | int     |
+---------------+---------+
(id, unique_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id and the corresponding unique id of an employee in the company.
 

Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.

Return the result table in any order.

Solution:

SELECT 
    e2.unique_id,
    e.name
FROM Employees e
LEFT JOIN EmployeeUNI e2 
    ON e.id = e2.id

=================================================================================================================================

Q6: Product Sales Analysis I

Table: Sales
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key (combination of columns with unique values) of this table.
product_id is a foreign key (reference column) to Product table.
Each row of this table shows a sale on the product product_id in a certain year.
Note that the price is per unit.
 
Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id is the primary key (column with unique values) of this table.
Each row of this table indicates the product name of each product.
 

Write a solution to report the product_name, year, and price for each sale_id in the Sales table.

Return the resulting table in any order.


Solution:

SELECT 
    p.product_name,
    s.year,
    s.price
FROM Sales s
JOIN Product p 
    ON s.product_id = p.product_id


=================================================================================================================================

Q7: Rising Temperature

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
There are no different rows with the same recordDate.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

Solution:

WITH Ranked AS (
    SELECT 
        w.id,
        w.recordDate,
        w.temperature,
        LAG(w.temperature) OVER (ORDER BY w.recordDate) AS PreviousTemp,
        LAG(w.recordDate) OVER (ORDER BY w.recordDate) AS PreviousDate
    FROM Weather w
)

SELECT 
    r.id
FROM Ranked r
WHERE 
    r.PreviousTemp < r.temperature
    AND ABS(DATEDIFF(day, r.recordDate, r.PreviousDate)) < 2


=================================================================================================================================


Q8: Average Time of Process per Machine

Table: Activity
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
The table shows the user activities for a factory website.
(machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
machine_id is the ID of a machine.
process_id is the ID of a process running on the machine with ID machine_id.
activity_type is an ENUM (category) of type ('start', 'end').
timestamp is a float representing the current time in seconds.
'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
It is guaranteed that each (machine_id, process_id) pair has a 'start' and 'end' timestamp.
 

There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

Return the result table in any order.

Solution:

SELECT 
    a.machine_id,
    ROUND(
        SUM(
            CASE 
                WHEN a.activity_type = 'start' THEN -a.timestamp
                ELSE a.timestamp
            END
        ) * 1.0 
        / COUNT(DISTINCT a.process_id),
        3
    ) AS processing_time
FROM Activity a
GROUP BY a.machine_id

=================================================================================================================================

Q9: Employee Bonus
Table: Employee
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| empId       | int     |
| name        | varchar |
| supervisor  | int     |
| salary      | int     |
+-------------+---------+
empId is the column with unique values for this table.
Each row of this table indicates the name and the ID of an employee in addition to their salary and the id of their manager.
 

Table: Bonus

+-------------+------+
| Column Name | Type |
+-------------+------+
| empId       | int  |
| bonus       | int  |
+-------------+------+
empId is the column of unique values for this table.
empId is a foreign key (reference column) to empId from the Employee table.
Each row of this table contains the id of an employee and their respective bonus.
 

Write a solution to report the name and bonus amount of each employee who satisfies either of the following:

The employee has a bonus less than 1000.
The employee did not get any bonus.
Return the result table in any order.

Solution:

SELECT 
    e.name,
    b.bonus
FROM Employee e
LEFT JOIN Bonus b 
    ON e.empId = b.empId
WHERE 
    b.bonus IS NULL
    OR b.bonus < 1000

=================================================================================================================================

Q10: Students and Examinations

Table: Students
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the primary key (column with unique values) for this table.
Each row of this table contains the ID and the name of one student in the school.
 

Table: Subjects

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
subject_name is the primary key (column with unique values) for this table.
Each row of this table contains the name of one subject in the school.
 

Table: Examinations

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
There is no primary key (column with unique values) for this table. It may contain duplicates.
Each student from the Students table takes every course from the Subjects table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
 

Write a solution to find the number of times each student attended each exam.

Return the result table ordered by student_id and subject_name.


Solution:
SELECT
    S.student_id
    ,S.student_name
    ,Su.subject_name
    ,COUNT(E.student_id) attended_exams
FROM Students S
CROSS JOIN Subjects Su
LEFT JOIN Examinations E
    ON S.student_id = E.student_id
    AND Su.subject_name = E.subject_name
GROUP BY S.student_id, S.student_name, Su.subject_name
ORDER BY S.student_id, S.student_name, Su.subject_name


Q11: Managers with at Least 5 Direct Reports

Table: Employee
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
 

Write a solution to find managers with at least five direct reports.

Return the result table in any order.


Solution:

SELECT 
    e.name
FROM Employee e
WHERE e.id IN (
    SELECT 
        managerId
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5

=================================================================================================================================


Q11: Confirmation Rate

Table: Signups
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
user_id is the column of unique values for this table.
Each row contains information about the signup time for the user with ID user_id.
 

Table: Confirmations

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
+----------------+----------+
(user_id, time_stamp) is the primary key (combination of columns with unique values) for this table.
user_id is a foreign key (reference column) to the Signups table.
action is an ENUM (category) of the type ('confirmed', 'timeout')
Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp and that confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').
 

The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.

Write a solution to find the confirmation rate of each user.

Return the result table in any order.

Solution:

WITH FlagTable AS (
    SELECT 
        s.user_id,
        c.action,
        CASE 
            WHEN c.action = 'timeout' THEN 0
            WHEN c.action IS NULL THEN 0
            ELSE 1 
        END AS flag
    FROM Signups s
    LEFT JOIN Confirmations c 
        ON c.user_id = s.user_id
)

SELECT 
    f.user_id,
    ROUND((SUM(flag) * 1.0 / COUNT(flag)), 2) AS confirmation_rate
FROM FlagTable f
GROUP BY f.user_id
ORDER BY confirmation_rate 

=================================================================================================================================


Q12: Not Boring Movies
Table: Cinema

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| id             | int      |
| movie          | varchar  |
| description    | varchar  |
| rating         | float    |
+----------------+----------+
id is the primary key (column with unique values) for this table.
Each row contains information about the name of a movie, its genre, and its rating.
rating is a 2 decimal places float in the range [0, 10]
 

Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".

Return the result table ordered by rating in descending order.

Solution:

SELECT *
FROM Cinema
WHERE id % 2 = 1 AND description <> 'boring'
ORDER BY rating DESC



=================================================================================================================================

Q13:Average Selling Price

Table: Prices
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id, start_date, end_date) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 

Table: UnitsSold

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
This table may contain duplicate rows.
Each row of this table indicates the date, units, and product_id of each product sold. 
 

Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. If a product does not have any sold units, its average selling price is assumed to be 0.

Return the result table in any order.



Solution:

SELECT p.product_id,
       COALESCE(ROUND(SUM(p.price * u.units * 1.0) / SUM(u.units), 2), 0) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
  ON p.product_id = u.product_id
 AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id


=================================================================================================================================


Q14:Project Employees I

Table: Project
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to Employee table.
Each row of this table indicates that the employee with employee_id is working on the project with project_id.
 

Table: Employee

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key of this table. It's guaranteed that experience_years is not NULL.
Each row of this table contains information about one employee.
 

Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

Return the result table in any order.

The query result format is in the following example.



Solution:

SELECT 
    p.project_id,
    ROUND(AVG(e.experience_years * 1.0), 2) AS average_years
FROM Project p
JOIN Employee e 
    ON p.employee_id = e.employee_id
GROUP BY p.project_id


=================================================================================================================================
Q15:Percentage of Users Attended a Contest

Table: Users
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
user_id is the primary key (column with unique values) for this table.
Each row of this table contains the name and the id of a user.
 

Table: Register

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
(contest_id, user_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id of a user and the contest they registered into.
 

Write a solution to find the percentage of the users registered in each contest rounded to two decimals.

Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order. 

Solution:

SELECT 
    r.contest_id,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(u.user_id) FROM Users u),
        2
    ) AS percentage
FROM Register r
GROUP BY r.contest_id
ORDER BY 
    percentage DESC,
    r.contest_id


=================================================================================================================================

Q16:Queries Quality and Percentage

Table: Queries
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| query_name  | varchar |
| result      | varchar |
| position    | int     |
| rating      | int     |
+-------------+---------+
This table may have duplicate rows.
This table contains information collected from some queries on a database.
The position column has a value from 1 to 500.
The rating column has a value from 1 to 5. Query with rating less than 3 is a poor query.
 

We define query quality as:

The average of the ratio between query rating and its position.

We also define poor query percentage as:

The percentage of all queries with rating less than 3.

Write a solution to find each query_name, the quality and poor_query_percentage.

Both quality and poor_query_percentage should be rounded to 2 decimal places.

Solution:

SELECT 
    query_name,
    ROUND(AVG(rating * 1.0 / position), 2) AS quality,
    ROUND(
        SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100.0 
        / COUNT(rating), 
    2) AS poor_query_percentage
FROM Queries
WHERE query_name IS NOT NULL
GROUP BY query_name

=================================================================================================================================

Q17:Monthly Transactions I

Table: Transactions
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
 

Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

Return the result table in any order.

Solution:

SELECT 
    FORMAT(trans_date, 'yyyy-MM') AS month,
    country,
    COUNT(id) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount, 
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY FORMAT(trans_date, 'yyyy-MM'), country

=================================================================================================================================


Q18:Immediate Food Delivery II

Table: Delivery
+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the column of unique values of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 

If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places. 

Solution:

WITH FirstOrders AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id 
               ORDER BY order_date
           ) AS rn
    FROM Delivery
)

SELECT 
    ROUND(
        SUM(CASE 
            WHEN order_date = customer_pref_delivery_date THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*)
    , 2) AS immediate_percentage
FROM FirstOrders
WHERE rn = 1


=================================================================================================================================

Q19:Game Play Analysis IV

Table: Activity
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.

Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places.
In other words, you need to determine the number of players who logged in on the day immediately following their initial login, and divide it by the number of total players.


Solution: 

SELECT 
    ROUND(
        AVG(CASE 
            WHEN a2.player_id IS NOT NULL THEN 1.0 
            ELSE 0 
        END)
    ,2) AS fraction
FROM (
    SELECT player_id, MIN(event_date) AS first_login
    FROM Activity
    GROUP BY player_id
) f
LEFT JOIN Activity a2
    ON f.player_id = a2.player_id
   AND a2.event_date = DATEADD(day, 1, f.first_login)


=================================================================================================================================


Q20: Number of Unique Subjects Taught by Each Teacher

Table: Teacher
+-------------+------+
| Column Name | Type |
+-------------+------+
| teacher_id  | int  |
| subject_id  | int  |
| dept_id     | int  |
+-------------+------+
(subject_id, dept_id) is the primary key (combinations of columns with unique values) of this table.
Each row in this table indicates that the teacher with teacher_id teaches the subject subject_id in the department dept_id.
 

Write a solution to calculate the number of unique subjects each teacher teaches in the university.

Return the result table in any order.

Solution: 

SELECT 
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM 
    teacher
GROUP BY 
    teacher_id

=================================================================================================================================

Q21: User Activity for the Past 30 Days I

Table: Activity
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
This table may have duplicate rows.
The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
The table shows the user activities for a social media website. 
Note that each session belongs to exactly one user.
 

Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.

Return the result table in any order.

The result format is in the following example.

Note: Any activity from ('open_session', 'end_session', 'scroll_down', 'send_message') will be considered valid activity for a user to be considered active on a day.

Solution: 

SELECT 
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM 
    activity
GROUP BY 
    activity_date
HAVING 
    activity_date > '2019-06-27'
    AND activity_date <= '2019-07-27'


=================================================================================================================================


Q22: Product Sales Analysis III

Table: Sales
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key (combination of columns with unique values) of this table.
Each row records a sale of a product in a given year.
A product may have multiple sales entries in the same year.
Note that the per-unit price.

Write a solution to find all sales that occurred in the first year each product was sold.

For each product_id, identify the earliest year it appears in the Sales table.

Return all sales entries for that product in that year.

Return a table with the following columns: product_id, first_year, quantity, and price.
Return the result in any order.

Solution: 

WITH FirstYearForEachProduct AS (
    SELECT 
        product_id,
        year,
        ROW_NUMBER() OVER (
            PARTITION BY product_id 
            ORDER BY year
        ) AS rn
    FROM 
        Sales
)

SELECT 
    s.product_id,
    f.year AS first_year,
    s.quantity,
    s.price
FROM 
    Sales s
INNER JOIN 
    FirstYearForEachProduct f
        ON s.product_id = f.product_id
       AND s.year = f.year
       AND f.rn = 1


=================================================================================================================================


Q23: Classes With at Least 5 Students

Table: Courses
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student     | varchar |
| class       | varchar |
+-------------+---------+
(student, class) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the name of a student and the class in which they are enrolled.
 

Write a solution to find all the classes that have at least five students.

Return the result table in any order.

Solution: 

SELECT 
    class
FROM 
    courses
GROUP BY 
    class
HAVING 
    COUNT(student) >= 5

=================================================================================================================================

Q24:Find Followers Count

Table: Followers
+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| follower_id | int  |
+-------------+------+
(user_id, follower_id) is the primary key (combination of columns with unique values) for this table.
This table contains the IDs of a user and a follower in a social media app where the follower follows the user.
 

Write a solution that will, for each user, return the number of followers.

Return the result table ordered by user_id in ascending order.

Solution:

SELECT 
    user_id,
    COUNT(*) AS followers_count
FROM 
    followers
GROUP BY 
    user_id

=================================================================================================================================

Q25: Biggest Single Number

Table: MyNumbers
+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
+-------------+------+
This table may contain duplicates (In other words, there is no primary key for this table in SQL).
Each row of this table contains an integer.
 

A single number is a number that appeared only once in the MyNumbers table.

Find the largest single number. If there is no single number, report null.


Solution:

SELECT (
    SELECT TOP 1 Num
    FROM MyNumbers
    GROUP BY Num
    HAVING COUNT(*) = 1
    ORDER BY Num DESC
) AS Num

=================================================================================================================================

Q26: Customers Who Bought All Products

Table: Customer
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
This table may contain duplicates rows. 
customer_id is not NULL.
product_key is a foreign key (reference column) to Product table.
 

Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key (column with unique values) for this table.
 

Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.


Solution:

SELECT 
    Customer_ID
FROM 
    Customer
GROUP BY 
    Customer_ID
HAVING 
    COUNT(DISTINCT Product_Key) = (
        SELECT COUNT(Product_Key) 
        FROM Product
    )

=================================================================================================================================


Q27:The Number of Employees Which Report to Each Employee

Table: Employees
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| reports_to  | int      |
| age         | int      |
+-------------+----------+
employee_id is the column with unique values for this table.
This table contains information about the employees and the id of the manager they report to. Some employees do not report to anyone (reports_to is null). 
 

For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.

Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.

Return the result table ordered by employee_id.

Solution: 

SELECT 
    E.Employee_ID,
    E.Name,
    COUNT(*) AS Reports_Count,
    ROUND(AVG(E2.Age * 1.0), 0) AS Average_Age
FROM 
    Employees E
JOIN 
    Employees E2 
    ON E.Employee_ID = E2.Reports_To
GROUP BY 
    E.Employee_ID,
    E.Name
ORDER BY 
    E.Employee_ID

=================================================================================================================================

Q28: Primary Department for Each Employee

Table: Employee
+---------------+---------+
| Column Name   |  Type   |
+---------------+---------+
| employee_id   | int     |
| department_id | int     |
| primary_flag  | varchar |
+---------------+---------+
(employee_id, department_id) is the primary key (combination of columns with unique values) for this table.
employee_id is the id of the employee.
department_id is the id of the department to which the employee belongs.
primary_flag is an ENUM (category) of type ('Y', 'N'). If the flag is 'Y', the department is the primary department for the employee. If the flag is 'N', the department is not the primary.
 

Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.

Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.

Return the result table in any order.

Solution:

SELECT 
    Employee_ID,
    Department_ID
FROM 
    Employee
WHERE 
    Primary_Flag = 'Y'
    OR Employee_ID IN (
        SELECT 
            Employee_ID
        FROM 
            Employee
        GROUP BY 
            Employee_ID
        HAVING 
            COUNT(Employee_ID) = 1
    )


=================================================================================================================================

Q29: Triangle Judgement

Table: Triangle
+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
In SQL, (x, y, z) is the primary key column for this table.
Each row of this table contains the lengths of three line segments.
 

Report for every three line segments whether they can form a triangle.

Return the result table in any order.

Solution:

SELECT 
    X,
    Y,
    Z,
    CASE 
        WHEN (X + Y <= Z)
          OR (X + Z <= Y)
          OR (Y + Z <= X)
        THEN 'No'
        ELSE 'Yes'
    END AS Triangle
FROM 
    Triangle

=================================================================================================================================

Q30: Consecutive Numbers

Table: Logs
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column starting from 1.
 

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

Solution:

SELECT DISTINCT
    Num AS ConsecutiveNums
FROM (
    SELECT 
        Num,
        LEAD(Num, 1) OVER (ORDER BY Id) AS Next1,
        LEAD(Num, 2) OVER (ORDER BY Id) AS Next2
    FROM 
        Logs
) T
WHERE 
    Num = Next1
    AND Num = Next2

=================================================================================================================================

Q31: Product Price at a Given Date

Table: Products
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key (combination of columns with unique values) of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
Initially, all products have price 10.

Write a solution to find the prices of all products on the date 2019-08-16.

Return the result table in any order.

Solution:

WITH LatestDate AS (
    SELECT *
    FROM (
        SELECT 
            Product_ID,
            New_Price AS Price,
            Change_Date,
            ROW_NUMBER() OVER (
                PARTITION BY Product_ID 
                ORDER BY Change_Date DESC
            ) AS RN
        FROM 
            Products
        WHERE 
            Change_Date <= '2019-08-16'
    ) T
    WHERE 
        T.RN = 1
)

SELECT 
    Product_ID,
    Price
FROM 
    LatestDate

UNION

SELECT 
    Product_ID,
    10 AS Price
FROM 
    Products
WHERE 
    Product_ID NOT IN (
        SELECT Product_ID 
        FROM LatestDate
    )


=================================================================================================================================

Q32: Last Person to Fit in the Bus

Table: Queue
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id column contains unique values.
This table has the information about all people waiting for a bus.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
turn determines the order of which the people will board the bus, where turn=1 denotes the first person to board and turn=n denotes the last person to board.
weight is the weight of the person in kilograms.
 

There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.

Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit. The test cases are generated such that the first person does not exceed the weight limit.

Note that only one person can board the bus at any given turn.

The result format is in the following example.

 

Example 1:

Input: 
Queue table:
+-----------+-------------+--------+------+
| person_id | person_name | weight | turn |
+-----------+-------------+--------+------+
| 5         | Alice       | 250    | 1    |
| 4         | Bob         | 175    | 5    |
| 3         | Alex        | 350    | 2    |
| 6         | John Cena   | 400    | 3    |
| 1         | Winston     | 500    | 6    |
| 2         | Marie       | 200    | 4    |
+-----------+-------------+--------+------+
Output: 
+-------------+
| person_name |
+-------------+
| John Cena   |
+-------------+
Explanation: The folowing table is ordered by the turn for simplicity.
+------+----+-----------+--------+--------------+
| Turn | ID | Name      | Weight | Total Weight |
+------+----+-----------+--------+--------------+
| 1    | 5  | Alice     | 250    | 250          |
| 2    | 3  | Alex      | 350    | 600          |
| 3    | 6  | John Cena | 400    | 1000         | (last person to board)
| 4    | 2  | Marie     | 200    | 1200         | (cannot board)
| 5    | 4  | Bob       | 175    | ___          |
| 6    | 1  | Winston   | 500    | ___          |
+------+----+-----------+--------+--------------+


Solution:

SELECT TOP 1
    Person_Name
FROM (
    SELECT 
        Turn,
        Person_Name,
        SUM(Weight) OVER (ORDER BY Turn) AS Total_Weight
    FROM 
        Queue
) T
WHERE 
    T.Total_Weight <= 1000
ORDER BY 
    Turn DESC

=================================================================================================================================

Q33: Count Salary Categories

Table: Accounts
+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key (column with unique values) for this table.
Each row contains information about the monthly income for one bank account.
 

Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, return 0.

Return the result table in any order.



Solution:

SELECT
    'Low Salary' AS Category,
    COUNT(CASE WHEN Income < 20000 THEN 1 END) AS Accounts_Count
FROM Accounts
UNION ALL
SELECT
    'Average Salary' AS Category,
    COUNT(CASE WHEN Income >= 20000 AND Income <= 50000 THEN 1 END) AS Accounts_Count
FROM Accounts
UNION ALL
SELECT
    'High Salary' AS Category,
    COUNT(CASE WHEN Income > 50000 THEN 1 END) AS Accounts_Count
FROM Accounts

=================================================================================================================================

Q34: Employees Whose Manager Left the Company

Table: Employees
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| manager_id  | int      |
| salary      | int      |
+-------------+----------+
In SQL, employee_id is the primary key for this table.
This table contains information about the employees, their salary, and the ID of their manager. Some employees do not have a manager (manager_id is null). 
 

Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.

Return the result table ordered by employee_id.


Solution:

SELECT Employee_Id
FROM Employees
WHERE Salary < 30000
AND Manager_Id NOT IN (
    SELECT Employee_Id
    FROM Employees
)
ORDER BY Employee_Id
=================================================================================================================================

Q35: Exchange Seats

Table: Seat
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key (unique value) column for this table.
Each row of this table indicates the name and the ID of a student.
The ID sequence always starts from 1 and increments continuously.
 

Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.

Return the result table ordered by id in ascending order.


Solution:

SELECT
    Id,
    CASE
        WHEN Id % 2 = 0
            THEN LAG(Student) OVER (ORDER BY Id)
        ELSE COALESCE(
            LEAD(Student) OVER (ORDER BY Id),
            Student
        )
    END AS Student
FROM Seat

=================================================================================================================================

Q36: Movie Rating

Table: Movies
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id is the primary key (column with unique values) for this table.
title is the name of the movie.
Each movie has a unique title.

Table: Users
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id is the primary key (column with unique values) for this table.
The column 'name' has unique values.

Table: MovieRating
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) is the primary key (column with unique values) for this table.
This table contains the rating of a movie by a user in their review.
created_at is the user's review date. 
 

Write a solution to:

Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.


Solution:

SELECT Results
FROM (
    SELECT TOP 1
        U.Name AS Results
    FROM Users U
    JOIN MovieRating MR
        ON U.User_Id = MR.User_Id
    GROUP BY U.Name
    ORDER BY COUNT(*) DESC, U.Name ASC
) A

UNION ALL

SELECT Results
FROM (
    SELECT TOP 1
        M.Title AS Results
    FROM Movies M
    JOIN MovieRating MR
        ON M.Movie_Id = MR.Movie_Id
    WHERE MR.Created_at BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY M.Title
    ORDER BY AVG(MR.Rating * 1.0) DESC, M.Title ASC
) B

=================================================================================================================================

Q37: 


Solution:


=================================================================================================================================

Q38: 


Solution:


=================================================================================================================================
=================================================================================================================================
=================================================================================================================================














