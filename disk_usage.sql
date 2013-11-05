-- List tables by total disk usage (including indexes).

CREATE OR REPLACE VIEW disk_usage AS
 SELECT pg_namespace.nspname AS schema, pg_class.relname AS relation,
    pg_size_pretty(pg_total_relation_size(pg_class.oid::regclass)) AS size,
    COALESCE(pg_stat_user_tables.seq_scan + pg_stat_user_tables.idx_scan, 0) AS scans
   FROM pg_class
   LEFT JOIN pg_stat_user_tables ON pg_stat_user_tables.relid = pg_class.oid
   LEFT JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace
  WHERE pg_class.relkind = 'r'::"char"
  AND pg_namespace.nspname NOT IN ('pg_catalog', 'information_schema')
  ORDER BY pg_total_relation_size(pg_class.oid::regclass) DESC;
