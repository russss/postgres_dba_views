-- A simple view to show active and waiting queries

CREATE OR REPLACE VIEW ps AS
 SELECT pg_stat_activity.pid,
    (host(pg_stat_activity.client_addr) || ':' || pg_stat_activity.client_port) AS client,
    pg_stat_activity.usename AS "user",
    now() - pg_stat_activity.xact_start AS age,
    pg_stat_activity.wait_event_type,
   (SELECT string_agg(relname, ', ') FROM pg_locks, pg_class
	WHERE pg_locks.pid = pid
	AND pg_locks.relation = pg_class.oid
	AND pg_locks.granted = false
   ) AS waiting_for_tables,
    CASE WHEN pg_stat_activity.state = 'active'::text THEN
      pg_stat_activity.query
    ELSE
      pg_stat_activity.state
   END
   FROM pg_stat_activity
  WHERE pg_stat_activity.state <> 'idle'::text
  ORDER BY now() - pg_stat_activity.xact_start DESC;
