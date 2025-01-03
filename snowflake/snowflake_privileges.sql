-- create the database, schema and warehouse
USE ROLE sysadmin;
CREATE DATABASE stock_db;
-- CREATE SCHEMA stock_db.tickers;
CREATE SCHEMA stock_db.raw;
CREATE WAREHOUSE stock_wh;

-- create the role that will use the Kafka connector
USE ROLE securityadmin;
CREATE ROLE kafka_connector_role;

-- grant privileges to the role
GRANT USAGE ON DATABASE stock_db TO ROLE kafka_connector_role;
GRANT USAGE ON WAREHOUSE stock_wh TO ROLE kafka_connector_role;
GRANT USAGE ON SCHEMA stock_db.tickers TO ROLE kafka_connector_role;
GRANT USAGE ON SCHEMA stock_db.raw TO ROLE kafka_connector_role;
-- GRANT CREATE TABLE ON SCHEMA stock_db.tickers TO ROLE kafka_connector_role;
-- GRANT CREATE STAGE ON SCHEMA stock_db.tickers TO ROLE kafka_connector_role;
-- GRANT CREATE PIPE ON SCHEMA stock_db.tickers TO ROLE kafka_connector_role;

GRANT CREATE TABLE ON SCHEMA stock_db.raw TO ROLE kafka_connector_role;
GRANT CREATE STAGE ON SCHEMA stock_db.raw TO ROLE kafka_connector_role;
GRANT CREATE PIPE ON SCHEMA stock_db.raw TO ROLE kafka_connector_role;

USER ROLE useradmin;
CREATE USER kafka_user PASSWORD='<REDACTED>' MUST_CHANGE_PASSWORD=FALSE;

-- grant the role to an existing user and set the role as the default for the user
USER ROLE securityadmin;
GRANT ROLE kafka_connector_role TO USER kafka_user;
ALTER USER kafka_user SET DEFAULT_ROLE = kafka_connector_role;
ALTER USER kafka_user SET DEFAULT_WAREHOUSE = stock_wh;

-- create role hierarchy
USER ROLE securityadmin;
CREATE ROLE engineer;
GRANT ROLE kafka_connector_rolr TO ROLE engineer;
GRANT ROLE engineer TO ROLE sysadmin;