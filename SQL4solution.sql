#511. Game Play Analysis I
#If we swipe the min date to max date
SELECT player_id, MIN(event_date) as 'first_login'
FROM Activity
GROUP BY player_id;

SELECT DISTINCT player_id, MIN(event_date) OVER (PARTITION BY player_id Order by event_date) AS 'first_login'
FROM Activity;

SELECT DISTINCT player_id, MIN(event_date) OVER (PARTITION BY player_id) AS 'first_login'
FROM Activity;

#using RANK()
SELECT a.player_id, a.event_date AS 'first_login'
FROM (
    SELECT b.player_id, b.event_date, RANK() OVER(PARTITION BY b.player_id ORDER BY b.event_date) AS 'rnk'
    FROM Activity b
) a WHERE a.rnk =1;

#Using FIRST_VALUE()
SELECT DISTINCT a.player_id, FIRST_VALUE(a.event_date) OVER (PARTITION BY a.player_id ORDER BY a.event_date) AS 'first_login' FROM Activity a;

#Using LAST_VALUE() , RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUND FOLLOWING.
SELECT DISTINCT a.player_id, LAST_VALUE(a.event_date) OVER (PARTITION BY a.player_id ORDER BY a.event_date DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'first_login' FROM Activity a;

#Using DENSE_RANK()
SELECT a.player_id, a.event_date AS 'first_login'
FROM (
    SELECT b.player_id, b.event_date, DENSE_RANK() OVER(PARTITION BY b.player_id ORDER BY b.event_date) AS 'rnk'
    FROM Activity b
) a WHERE a.rnk =1;

#Using ROW_NUMBER()
SELECT a.player_id, a.event_date AS 'first_login'
FROM (
    SELECT b.player_id, b.event_date, ROW_NUMBER() OVER(PARTITION BY b.player_id ORDER BY b.event_date) AS 'rnk'
    FROM Activity b
) a WHERE a.rnk =1;

#512. Game Play Analysis II-----
# Write your MySQL query statement below
SELECT DISTINCT a.player_id, a.device_id
FROM Activity a
WHERE a.event_date IN (
    SELECT MIN(b.event_date)
FROM Activity b WHERE a.player_id = b.player_id);

# taking too much of time(time exceeded)
SELECT a.player_id, a.device_id
FROM Activity a WHERE a.event_date =(
    SELECT MIN(b.event_date) FROM Activity b WHERE a.player_id = b.player_id
);

#Using DENSE_RANK()
WITH CTE AS (
    SELECT player_id, device_id, DENSE_RANK() OVER(PARTITION BY player_id ORDER BY event_date) AS
    'rnk' FROM Activity)
SELECT player_id, device_id FROM CTE WHERE rnk = 1;

#Using FIRST_VALUE()
SELECT DISTINCT player_id, FIRST_VALUE(device_id) OVER(PARTITION BY player_id ORDER BY event_date) AS 'device_id'
FROM Activity;

#Using LAST_VALUE()
SELECT DISTINCT player_id, LAST_VALUE(device_id) OVER(PARTITION BY player_id ORDER BY event_date DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'device_id'
FROM Activity;
