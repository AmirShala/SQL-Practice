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























  
"""
