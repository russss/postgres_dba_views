-- A simple view to show active and waiting queries

CREATE OR REPLACE VIEW ps AS
 SELECT pg_stat_activity.pid, pg_stat_activity.client_addr,
    pg_stat_activity.client_port, pg_stat_activity.usename,
    now() - pg_stat_activity.xact_start AS age,
    CASE WHEN pg_stat_activity.state = 'active'::text THEN
      pg_stat_activity.query
    ELSE
      pg_stat_activity.state
   END,
   pg_stat_activity.waiting
   FROM pg_stat_activity
  WHERE pg_stat_activity.state <> 'idle'::text
  ORDER BY now() - pg_stat_activity.xact_start DESC;
