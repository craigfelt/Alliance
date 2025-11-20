-- Alliance Property Management System - Database Creation Script
-- This script creates the alliance_property database
-- Run this script when connected to the 'postgres' database

-- Terminate existing connections to the database (if any)
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'alliance_property'
  AND pid <> pg_backend_pid();

-- Drop database if it exists (for clean reinstallation)
DROP DATABASE IF EXISTS alliance_property;

-- Create the database
-- Note: Using template0 and C locale for maximum compatibility across systems
CREATE DATABASE alliance_property
  WITH 
  ENCODING = 'UTF8'
  LC_COLLATE = 'C'
  LC_CTYPE = 'C'
  TEMPLATE = template0
  OWNER = postgres;

-- Grant all privileges to postgres user
GRANT ALL PRIVILEGES ON DATABASE alliance_property TO postgres;
