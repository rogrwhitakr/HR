
SELECT 
    pid, 
    now() - pg_stat_activity.query_start AS duration, 
    state, 
    datname, 
    query 
FROM pg_stat_activity 
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes' 
ORDER BY duration DESC;
SELECT pg_terminate_backend(__pid__);