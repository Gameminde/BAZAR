-- BAZAR Marketplace - PostgreSQL Setup Script
-- Run this script as PostgreSQL superuser to create databases and users

-- Create production database and user
CREATE DATABASE bazar_marketplace;
CREATE USER bazar_user WITH ENCRYPTED PASSWORD 'bazar_password';
GRANT ALL PRIVILEGES ON DATABASE bazar_marketplace TO bazar_user;

-- Create development database and user
CREATE DATABASE bazar_marketplace_dev;
CREATE USER bazar_dev WITH ENCRYPTED PASSWORD 'bazar_dev_password';
GRANT ALL PRIVILEGES ON DATABASE bazar_marketplace_dev TO bazar_dev;

-- Create test database and user
CREATE DATABASE bazar_marketplace_test;
CREATE USER bazar_test WITH ENCRYPTED PASSWORD 'bazar_test_password';
GRANT ALL PRIVILEGES ON DATABASE bazar_marketplace_test TO bazar_test;

-- Grant additional permissions for development
ALTER USER bazar_dev CREATEDB;
ALTER USER bazar_test CREATEDB;

-- Connect to each database and grant schema permissions
\c bazar_marketplace;
GRANT ALL ON SCHEMA public TO bazar_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bazar_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bazar_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO bazar_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO bazar_user;

\c bazar_marketplace_dev;
GRANT ALL ON SCHEMA public TO bazar_dev;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bazar_dev;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bazar_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO bazar_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO bazar_dev;

\c bazar_marketplace_test;
GRANT ALL ON SCHEMA public TO bazar_test;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bazar_test;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bazar_test;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO bazar_test;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO bazar_test;

-- Display created databases
\l bazar_marketplace*
