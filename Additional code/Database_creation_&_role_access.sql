
--Granting roles to role cobra_role To create database
GRANT CREATE WAREHOUSE ON ACCOUNT TO cobra_role;
GRANT CREATE DATABASE ON ACCOUNT TO cobra_role;
GRANT CREATE SCHEMA ON ACCOUNT TO cobra_role;
GRANT ROLE cobra_role TO USER cobra;

--create database F1_DB and warehouse f1
USE ROLE cobra_role;

CREATE WAREHOUSE f1;
CREATE DATABASE f1_db;

-- Create schemas in the database
CREATE SCHEMA f1_db.raw;
CREATE SCHEMA f1_db.refinement;
CREATE SCHEMA f1_db.delivery;

--Assigning privileges to roles for the 5 users
--Warehouse use
GRANT USAGE ON WAREHOUSE f1 TO ROLE cobra_role;
GRANT USAGE ON WAREHOUSE f1 TO ROLE grizzly_role;
GRANT USAGE ON WAREHOUSE f1 TO ROLE flamingo_role;
GRANT USAGE ON WAREHOUSE f1 TO ROLE jellyfish_role;
GRANT USAGE ON WAREHOUSE f1 TO ROLE eagle_role;



--Usage on database and schemas
GRANT USAGE ON DATABASE f1_db TO ROLE cobra_role;
GRANT USAGE ON DATABASE f1_db TO ROLE grizzly_role;
GRANT USAGE ON DATABASE f1_db TO ROLE flamingo_role;
GRANT USAGE ON DATABASE f1_db TO ROLE jellyfish_role;
GRANT USAGE ON DATABASE f1_db TO ROLE eagle_role;

GRANT USAGE ON SCHEMA f1_db.raw TO ROLE cobra_role;
GRANT USAGE ON SCHEMA f1_db.raw TO ROLE cobra_role;
GRANT USAGE ON SCHEMA f1_db.raw TO ROLE grizzly_role;
GRANT USAGE ON SCHEMA f1_db.raw TO ROLE flamingo_role;
GRANT USAGE ON SCHEMA f1_db.raw TO ROLE jellyfish_role;
GRANT USAGE ON SCHEMA f1_db.raw TO ROLE eagle_role;

GRANT USAGE ON SCHEMA f1_db.refinement TO ROLE cobra_role;
GRANT USAGE ON SCHEMA f1_db.refinement TO ROLE grizzly_role;
GRANT USAGE ON SCHEMA f1_db.refinement TO ROLE flamingo_role;
GRANT USAGE ON SCHEMA f1_db.refinement TO ROLE jellyfish_role;
GRANT USAGE ON SCHEMA f1_db.refinement TO ROLE eagle_role;

GRANT USAGE ON SCHEMA f1_db.delivery TO ROLE cobra_role;
GRANT USAGE ON SCHEMA f1_db.delivery TO ROLE grizzly_role;
GRANT USAGE ON SCHEMA f1_db.delivery TO ROLE flamingo_role;
GRANT USAGE ON SCHEMA f1_db.delivery TO ROLE jellyfish_role;
GRANT USAGE ON SCHEMA f1_db.delivery TO ROLE eagle_role;

--only cobra_role can create schema
GRANT CREATE SCHEMA ON DATABASE f1_db TO ROLE cobra_role;

--In order to grant create, select, etc... object privileges for all schemas, we need to use the TRAINING_ROLE
USE ROLE TRAINING_ROLE;
-- Granting object privileges to roles for the 5 users
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.raw TO ROLE cobra_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.raw TO ROLE grizzly_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.raw TO ROLE flamingo_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.raw TO ROLE jellyfish_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.raw TO ROLE eagle_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.refinement TO ROLE cobra_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.refinement TO ROLE grizzly_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.refinement TO ROLE flamingo_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.refinement TO ROLE jellyfish_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.refinement TO ROLE eagle_role;

GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.delivery TO ROLE cobra_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.delivery TO ROLE grizzly_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.delivery TO ROLE flamingo_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.delivery TO ROLE jellyfish_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.delivery TO ROLE eagle_role;


--additional schema privileges
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.raw TO ROLE cobra_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.raw TO ROLE grizzly_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.raw TO ROLE flamingo_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.raw TO ROLE jellyfish_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.raw TO ROLE eagle_role;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.refinement TO ROLE cobra_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.refinement TO ROLE grizzly_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.refinement TO ROLE flamingo_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.refinement TO ROLE jellyfish_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.refinement TO ROLE eagle_role;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.delivery TO ROLE cobra_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.delivery TO ROLE grizzly_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.delivery TO ROLE flamingo_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.delivery TO ROLE jellyfish_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.delivery TO ROLE eagle_role;

--create table and stage privileges. We will only create stages in Raw schema.
GRANT CREATE TABLE ON SCHEMA f1_db.delivery TO ROLE cobra_role;
GRANT CREATE TABLE ON SCHEMA f1_db.delivery TO ROLE grizzly_role;
GRANT CREATE TABLE ON SCHEMA f1_db.delivery TO ROLE flamingo_role;
GRANT CREATE TABLE ON SCHEMA f1_db.delivery TO ROLE jellyfish_role;
GRANT CREATE TABLE ON SCHEMA f1_db.delivery TO ROLE eagle_role;

GRANT CREATE TABLE ON SCHEMA f1_db.raw TO ROLE cobra_role;
GRANT CREATE TABLE ON SCHEMA f1_db.raw TO ROLE grizzly_role;
GRANT CREATE TABLE ON SCHEMA f1_db.raw TO ROLE flamingo_role;
GRANT CREATE TABLE ON SCHEMA f1_db.raw TO ROLE jellyfish_role;
GRANT CREATE TABLE ON SCHEMA f1_db.raw TO ROLE eagle_role;

GRANT CREATE STAGE ON SCHEMA f1_db.raw TO ROLE cobra_role;
GRANT CREATE STAGE ON SCHEMA f1_db.raw TO ROLE grizzly_role;
GRANT CREATE STAGE ON SCHEMA f1_db.raw TO ROLE flamingo_role;
GRANT CREATE STAGE ON SCHEMA f1_db.raw TO ROLE jellyfish_role;
GRANT CREATE STAGE ON SCHEMA f1_db.raw TO ROLE eagle_role;

GRANT CREATE TABLE ON SCHEMA f1_db.refinement TO ROLE cobra_role;
GRANT CREATE TABLE ON SCHEMA f1_db.refinement  TO ROLE grizzly_role;
GRANT CREATE TABLE ON SCHEMA f1_db.refinement  TO ROLE flamingo_role;
GRANT CREATE TABLE ON SCHEMA f1_db.refinement  TO ROLE jellyfish_role;
GRANT CREATE TABLE ON SCHEMA f1_db.refinement  TO ROLE eagle_role;


GRANT USAGE ON DATABASE F1_DB TO ROLE cobra_role;
GRANT USAGE ON SCHEMA F1_DB.raw TO ROLE cobra_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA F1_DB.raw TO ROLE cobra_role;

--for dbt use, eagle_role is also granted schema creation privileges

GRANT CREATE SCHEMA ON DATABASE F1_DB TO ROLE eagle_role;