#511. Game Play Analysis I
#If we swipe the min date to max date
SELECT player_id, MIN(event_date) as 'First_login'
FROM Activity
GROUP BY player_id;

SELECT DISTINCT player_id, MIN(event_date) OVER (PARTITION BY player_id Order by event_date)as 'First_login'
FROM Activity;

SELECT DISTINCT player_id, MIN(event_date) OVER (PARTITION BY player_id )as 'First_login'
FROM Activity;
