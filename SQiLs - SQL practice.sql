'''These Questions are from https://www.sqils.io/ , this site has interactive exercises and real-world examples.
    I am using SQLite syntax to solve these questions. 
    '''
/*
Q1:CAC Payback by Channel

Mission Background
As a Finance Analyst at a SaaS startup, your CFO needs to evaluate the efficiency of each acquisition channel. Customer Acquisition Cost (CAC) tells you how much you spend to acquire one customer, while the Payback Period tells you how many months of revenue it takes to recover that cost. Use the customers_771, campaigns_771, and subscriptions_771 tables to calculate both metrics per channel.


Analysis Requirements
Join the three tables to calculate CAC (total spend divided by number of customers) and Payback Period (CAC divided by average MRR) per acquisition channel.


Success Criteria
Your result should include:

channel — the acquisition channel name
CAC — Customer Acquisition Cost (total spend / number of customers), rounded to 2 decimals
AvgMRR — average Monthly Recurring Revenue per customer in that channel, rounded to 2 decimals
PaybackMonths — number of months to recover CAC (CAC / AvgMRR), rounded to 1 decimal
Ordering:

By payback months from lowest to highest

Solution:

SELECT
    ca.channel,
    ROUND(ca.total_spend / NULLIF(COUNT(DISTINCT c.customer_id), 0), 2) AS "CAC",
    ROUND(AVG(s.mrr), 2) AS "AvgMRR",
    ROUND(ca.total_spend / NULLIF(COUNT(DISTINCT c.customer_id), 0) / NULLIF(AVG(s.mrr), 0), 1) AS "PaybackMonths"
FROM campaigns_771 ca
JOIN customers_771 c ON c.acquisition_channel = ca.channel
JOIN subscriptions_771 s ON c.customer_id = s.customer_id
GROUP BY ca.channel, ca.total_spend
ORDER BY "PaybackMonths"


===========================================================================================================================================

Q2: Calculate Daily Work Hours

Mission Background
As a workforce analyst at a customer support center, you need to monitor shift hours for your team. The clockings_471 table records all login and logout events.


Analysis Requirements
Time Window: For each employee and date, identify the earliest clock-in time and latest clock-out time
Calculation: Compute the duration between these times expressed in hours with two decimal places
Filtering: Ensure every result has both IN and OUT events recorded

Success Criteria
Results show one row per employee per workday
Columns: employee_id, a new column representing the work date in YYYY-MM-DD format, and a new column representing the total hours worked as a numeric value
Hours calculated with precision to two decimal places
Ordering:

By date descending, then by employee ID ascending

Solution:

SELECT 
  employee_id,
  DATE(event_time) AS "WorkDate",
  ROUND(
    CAST(
      julianday(MAX(CASE WHEN event_type = 'OUT' THEN event_time END)) -
      julianday(MIN(CASE WHEN event_type = 'IN' THEN event_time END))
    AS REAL) * 24,
    2
  ) AS "HoursWorked"
FROM clockings_471
WHERE event_type IN ('IN', 'OUT')
GROUP BY employee_id, DATE(event_time)
HAVING MAX(CASE WHEN event_type = 'OUT' THEN event_time END) IS NOT NULL
   AND MIN(CASE WHEN event_type = 'IN' THEN event_time END) IS NOT NULL
ORDER BY "WorkDate" DESC, employee_id

===========================================================================================================================================

Q3: ssign Speakers To Rooms

Mission Background
As a Conference Organizer, you have a table of all possible speaker and room combinations. The conference_slots_645 table lists every speaker paired with every available room.


Analysis Requirements
From the full grid of combinations, produce a unique one to one assignment so that each speaker gets exactly one distinct room and no room is assigned to more than one speaker. Assign rooms in alphabetical order to speakers in alphabetical order.


Success Criteria
speaker_name
A new column representing the uniquely assigned room
Each speaker appears exactly once
Each room appears exactly once
The first alphabetical speaker gets the first alphabetical room, and so on
Ordering:

By speaker name ascending

Solution:

WITH ranked AS (
    SELECT
        speaker_name,
        room_name,
        ROW_NUMBER() OVER (PARTITION BY speaker_name ORDER BY room_name) AS room_seq,
        DENSE_RANK() OVER (ORDER BY speaker_name) AS speaker_seq
    FROM conference_slots_645
)
SELECT
    speaker_name AS "Speaker",
    room_name AS "AssignedRoom"
FROM ranked
WHERE room_seq = speaker_seq
ORDER BY speaker_name

===========================================================================================================================================

Q4: Abnormal Hire Gap Detection

Mission Background
As an HR Analyst, you want to identify periods of stagnant hiring. The employees table tracks hire dates that can reveal gaps in recruitment activity.


Analysis Requirements
Order employees by their hire date
Calculate the number of days between each hire and the previous hire
Identify employees hired after unusually long gaps

Success Criteria
Your query must return the following columns:

first_name: The employee first name
last_name: The employee last name
A column representing the days since the previous hire
Filtering Rules:

Only employees where the hire gap exceeds 300 days
Please note: The order of results does not matter.

Solution:

WITH HireSequences AS (
  SELECT 
    first_name AS FirstName,
    last_name AS LastName,
    julianday(hire_date) - julianday(LAG(hire_date) OVER (ORDER BY hire_date)) AS HireGap
  FROM employees
)
SELECT FirstName, LastName, HireGap 
FROM HireSequences 
WHERE HireGap > 300;

===========================================================================================================================================

Q5: Global freight accumulation milestone

Mission Background
As a Finance Analyst, you are tracking total operational costs over time. The orders table contains freight data that can reveal when cumulative shipping costs crossed significant milestones.


Analysis Requirements
Calculate a running total of freight costs across all orders
Order the calculation chronologically
Identify when the cumulative freight reached specific thresholds

Success Criteria
Your query must return the following columns:

order_id: The order identifier
order_date: The order date
A column representing the running sum of freight
Filtering Rules:

Only orders where the accumulated freight is between 10000 and 11000
Please note: The order of results does not matter.

Solution:

WITH GlobalFreight AS (
  SELECT 
    order_id AS OrderId,
    order_date AS OrderDate,
    SUM(freight) OVER (ORDER BY order_date, order_id) AS TotalAccumulatedFreight
  FROM orders
)
SELECT OrderId, OrderDate, TotalAccumulatedFreight 
FROM GlobalFreight 
WHERE TotalAccumulatedFreight BETWEEN 10000 AND 11000;

===========================================================================================================================================

Q6: Find the Middle Restaurants

Mission Background
As a hospitality awards coordinator, you are reviewing a shortlist of 10 restaurants stored in the restaurants_623 table. A judge has asked for the two middle-ranked restaurants as a calibration reference, without hardcoding positions. The query must work regardless of how many restaurants are in the list.


Analysis Requirements
Write a query that dynamically identifies and returns the two middle-ranked restaurants, without hardcoding any row numbers or position values.


Success Criteria
The restaurant name
Filtering Rules:

Return only the two rows at positions total divided by 2 and total divided by 2 plus 1
Ordering:

By restaurant ID ascending

Solution:

WITH ranked AS (
    SELECT restaurant_id, name,
           ROW_NUMBER() OVER (ORDER BY restaurant_id) AS rn,
           COUNT(*) OVER () AS total
    FROM restaurants_623
)
SELECT name
FROM ranked
WHERE rn BETWEEN total / 2 AND total / 2 + 1
ORDER BY restaurant_id

===========================================================================================================================================

Q7: Rank Distribution Center Coverage

Mission Background
As a Logistics Director, you oversee four regional distribution centers. The product_matrix_385 table records which product categories each center handles, using 1 (handles) and 0 (does not handle) indicators in separate columns for each center.


Analysis Requirements
Determine how many product categories each distribution center covers, and rank the centers from highest to lowest coverage.


Success Criteria
A column showing the distribution center name
A new column representing the total number of categories that center handles
A new column representing the ranking position based on category count (ties share the same rank)
Ordering:

By category count descending

Solution:

WITH unpivoted AS (
    SELECT category, 'North' AS center, center_north AS handles FROM product_matrix_385
    UNION ALL
    SELECT category, 'South', center_south FROM product_matrix_385
    UNION ALL
    SELECT category, 'East', center_east FROM product_matrix_385
    UNION ALL
    SELECT category, 'West', center_west FROM product_matrix_385
)
SELECT center AS "Center",
    SUM(handles) AS "CategoryCount",
    RANK() OVER (ORDER BY SUM(handles) DESC) AS "Rank"
FROM unpivoted
GROUP BY center
ORDER BY SUM(handles) DESC

===========================================================================================================================================

Q8: Split Invoices Across Months

Mission Background
As a Finance Controller, you manage the invoices_629 table which records billing periods that sometimes span two calendar months. For accurate monthly revenue reporting, you need to allocate each invoice's total amount to the correct months based on how many days fall in each month.


Analysis Requirements
For each invoice, calculate what portion of the total amount belongs to each month it spans. The allocation should be proportional to the number of days the invoice covers in each month relative to the total billing period length.


Success Criteria
The invoice ID
The client name
A new column representing the month label (YYYY-MM format)
A new column representing the allocated amount for that month rounded to two decimal places
Ordering:

By invoice ID ascending, then by month ascending

Solution:

WITH bounds AS (
    SELECT
        invoice_id,
        client,
        start_date,
        end_date,
        total_amount,
        CAST(julianday(end_date) - julianday(start_date) + 1 AS REAL) AS total_days
    FROM invoices_629
)
SELECT
    invoice_id AS "InvoiceId",
    client AS "Client",
    strftime('%Y-%m', start_date) AS "Month",
    ROUND(total_amount * (julianday(MIN(end_date, date(start_date, 'start of month', '+1 month', '-1 day'))) - julianday(start_date) + 1) / total_days, 2) AS "Amount"
FROM bounds
WHERE strftime('%Y-%m', start_date) <> strftime('%Y-%m', end_date)
UNION ALL
SELECT
    invoice_id,
    client,
    strftime('%Y-%m', end_date),
    ROUND(total_amount * (julianday(end_date) - julianday(MAX(start_date, date(end_date, 'start of month'))) + 1) / total_days, 2)
FROM bounds
WHERE strftime('%Y-%m', start_date) <> strftime('%Y-%m', end_date)
UNION ALL
SELECT
    invoice_id,
    client,
    strftime('%Y-%m', start_date),
    total_amount
FROM bounds
WHERE strftime('%Y-%m', start_date) = strftime('%Y-%m', end_date)
ORDER BY "InvoiceId", "Month"


===========================================================================================================================================

Q9: Forward Fill Missing Values

Mission Background
As a Logistics Data Analyst, you are working with the delivery_log_851 table. Due to a data entry shortcut, the region and city were only recorded for the first package in each group. Subsequent rows have NULL for these fields, but they belong to the same region and city as the last non-null entry above them.


Analysis Requirements
Fill every NULL region and city with the most recent non-null value that precedes it (based on the row ID ordering). Every row should display a complete region, city, and package code.


Success Criteria
A new column representing the filled region (never NULL)
A new column representing the filled city (never NULL)
The package code
Ordering:

By row ID ascending

Solution:

WITH filled AS (
    SELECT
        row_id,
        region,
        city,
        package_code,
        MAX(CASE WHEN region IS NOT NULL THEN row_id END) OVER (ORDER BY row_id) AS region_grp,
        MAX(CASE WHEN city IS NOT NULL THEN row_id END) OVER (ORDER BY row_id) AS city_grp
    FROM delivery_log_851
)
SELECT
    (SELECT d.region FROM delivery_log_851 AS d WHERE d.row_id = f.region_grp) AS "Region",
    (SELECT d.city FROM delivery_log_851 AS d WHERE d.row_id = f.city_grp) AS "City",
    f.package_code AS "PackageCode"
FROM filled AS f
ORDER BY f.row_id

===========================================================================================================================================

Q10: User Session Identification from Event Logs

Mission Background
As a Product Analyst, you need to identify user sessions from raw event logs. The user_events_583 table contains timestamped user events (page views, clicks, etc.). A session is defined as a sequence of events with no more than 30 minutes between consecutive events. Events more than 30 minutes apart start a new session.


Analysis Requirements
Identify sessions for each user by detecting gaps greater than 30 minutes. Calculate session metrics including event count, duration, and whether it was a bounce (single-event session).


Success Criteria
Your query must return the following columns:

user_id: The user identifier
A column representing the session number for that user (1, 2, 3...)
A column representing the count of events in the session
A column representing the session duration in minutes
A column indicating if the session is a bounce (Yes/No)
Definitions:

Session gap threshold: 30 minutes
Bounce: A session with only 1 event
Duration: Time between first and last event (0 for bounces)
Ordering:

By user_id ascending, then by session number ascending
This sessionization enables understanding user engagement patterns, identifying bounce rates, and measuring session quality.

Solution:

WITH EventGaps AS (
    SELECT 
        event_id,
        user_id,
        event_type,
        event_timestamp,
        LAG(event_timestamp) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS prev_timestamp,
        ROUND((julianday(event_timestamp) - julianday(LAG(event_timestamp) OVER (PARTITION BY user_id ORDER BY event_timestamp))) * 24 * 60, 1) AS minutes_since_last
    FROM user_events_583
),
SessionMarkers AS (
    SELECT 
        event_id,
        user_id,
        event_type,
        event_timestamp,
        CASE 
            WHEN prev_timestamp IS NULL THEN 1
            WHEN minutes_since_last > 30 THEN 1
            ELSE 0
        END AS is_new_session
    FROM EventGaps
),
SessionAssigned AS (
    SELECT 
        event_id,
        user_id,
        event_type,
        event_timestamp,
        SUM(is_new_session) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS session_num
    FROM SessionMarkers
),
SessionStats AS (
    SELECT 
        user_id,
        session_num,
        COUNT(*) AS event_count,
        ROUND((julianday(MAX(event_timestamp)) - julianday(MIN(event_timestamp))) * 24 * 60, 1) AS duration_minutes
    FROM SessionAssigned
    GROUP BY user_id, session_num
)
SELECT 
    user_id AS "UserID",
    session_num AS "SessionNum",
    event_count AS "EventCount",
    duration_minutes AS "DurationMinutes",
    CASE WHEN event_count = 1 THEN 'Yes' ELSE 'No' END AS "IsBounce"
FROM SessionStats
ORDER BY user_id, session_num;

===========================================================================================================================================

Q11: Product Affinity Analysis (Market Basket)

Mission Background
As a Merchandising Analyst, you need to identify product pairs that are frequently purchased together for cross-selling recommendations. The basket_products_265 table contains product information, and basket_order_items_265 tracks which products appear in each order. You must calculate affinity metrics to find strong product associations.


Analysis Requirements
Find product pairs that appear together in orders and calculate association metrics: Support (percentage of all orders containing both) and Confidence (given product A was purchased, what percentage also included product B, and vice versa). Round all percentage metrics to 1 decimal place using the ROUND function.


Success Criteria
Your query must return the following columns:

A column for the first product name in the pair
A column for the second product name in the pair
A column for how many orders contained both products
A column for support percentage (pair orders / total orders), rounded to 1 decimal place
A column for confidence A→B (pair orders / product A orders), rounded to 1 decimal place
A column for confidence B→A (pair orders / product B orders), rounded to 1 decimal place
Filtering Rules:

Only include pairs that appear together in at least 3 orders
Each pair should appear only once (not both A-B and B-A)
Ordering:

By times bought together descending, then by support percentage descending
High support indicates popular combinations. High confidence A→B means "customers who buy A usually also buy B" - ideal for "frequently bought together" recommendations.


Solution:


WITH TotalOrders AS (
    SELECT COUNT(DISTINCT order_id) AS total_orders
    FROM basket_order_items_265
),
ProductPairs AS (
    SELECT 
        a.product_id AS product_a,
        b.product_id AS product_b,
        COUNT(DISTINCT a.order_id) AS pair_count
    FROM basket_order_items_265 AS a
    JOIN basket_order_items_265 AS b 
        ON a.order_id = b.order_id 
        AND a.product_id < b.product_id
    GROUP BY a.product_id, b.product_id
),
ProductCounts AS (
    SELECT 
        product_id,
        COUNT(DISTINCT order_id) AS product_orders
    FROM basket_order_items_265
    GROUP BY product_id
),
AffinityMetrics AS (
    SELECT 
        pa.product_name AS product_a_name,
        pb.product_name AS product_b_name,
        pp.pair_count,
        pca.product_orders AS product_a_orders,
        pcb.product_orders AS product_b_orders,
        t.total_orders,
        ROUND(100.0 * pp.pair_count / t.total_orders, 1) AS support_pct,
        ROUND(100.0 * pp.pair_count / pca.product_orders, 1) AS confidence_a_to_b,
        ROUND(100.0 * pp.pair_count / pcb.product_orders, 1) AS confidence_b_to_a
    FROM ProductPairs AS pp
    JOIN basket_products_265 AS pa ON pp.product_a = pa.product_id
    JOIN basket_products_265 AS pb ON pp.product_b = pb.product_id
    JOIN ProductCounts AS pca ON pp.product_a = pca.product_id
    JOIN ProductCounts AS pcb ON pp.product_b = pcb.product_id
    CROSS JOIN TotalOrders AS t
)
SELECT 
    product_a_name AS "ProductA",
    product_b_name AS "ProductB",
    pair_count AS "TimesBoughtTogether",
    support_pct AS "SupportPct",
    confidence_a_to_b AS "ConfidenceAtoB",
    confidence_b_to_a AS "ConfidenceBtoA"
FROM AffinityMetrics
WHERE pair_count >= 3
ORDER BY pair_count DESC, support_pct DESC








































*/
