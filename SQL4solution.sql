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

#Using LAST_VALUE() , RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUND FOLLOWING. SIMILARLY , we can use DENSE_RANK() and ROW_NUMBER()
SELECT DISTINCT a.player_id, LAST_VALUE(a.event_date) OVER (PARTITION BY a.player_id ORDER BY a.event_date DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'first_login' FROM Activity a;



