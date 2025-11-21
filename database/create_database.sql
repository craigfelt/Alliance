-- Drop and recreate the alliance_property database (run connected to postgres)
REVOKE CONNECT ON DATABASE alliance_property FROM public;
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'alliance_property' AND pid <> pg_backend_pid();
DROP DATABASE IF EXISTS alliance_property;
CREATE DATABASE alliance_property
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       LC_COLLATE = 'C'
       LC_CTYPE = 'C'
       TEMPLATE = template0;
GRANT ALL PRIVILEGES ON DATABASE alliance_property TO postgres;