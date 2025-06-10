CREATE ROLE dashboard_role;

GRANT ROLE dashboard_role TO USER cobra;
GRANT ROLE dashboard_role TO USER grizzly;
GRANT ROLE dashboard_role TO USER flamingo;
GRANT ROLE dashboard_role TO USER eagle;
GRANT ROLE dashboard_role TO USER jellyfish;

GRANT USAGE ON WAREHOUSE f1 TO ROLE dashboard_role;
GRANT USAGE ON DATABASE f1_db TO ROLE dashboard_role;
GRANT USAGE ON SCHEMA f1_db.delivery TO ROLE dashboard_role;
GRANT USAGE ON SCHEMA f1_db.refinement TO ROLE dashboard_role;


GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA f1_db.delivery TO ROLE dashboard_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.delivery TO ROLE dashboard_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA f1_db.delivery TO ROLE dashboard_role;

GRANT SELECT ON ALL TABLES IN SCHEMA f1_db.refinement TO ROLE dashboard_role;
GRANT SELECT ON ALL VIEWS IN SCHEMA f1_db.refinement TO ROLE dashboard_role;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA f1_db.refinement TO ROLE dashboard_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA f1_db.refinement TO ROLE dashboard_role;

GRANT CREATE TABLE ON SCHEMA f1_db.delivery TO ROLE dashboard_role;
GRANT CREATE VIEW ON SCHEMA f1_db.delivery TO ROLE dashboard_role;

--Creating Dashboard Viewer role to share the dahsbord with clients
CREATE ROLE dashboard_viewer;
GRANT USAGE ON WAREHOUSE f1 TO ROLE dashboard_viewer;
GRANT USAGE ON DATABASE f1_db TO ROLE dashboard_viewer;
GRANT USAGE ON SCHEMA f1_db.delivery TO ROLE dashboard_viewer;
GRANT SELECT ON ALL TABLES IN SCHEMA f1_db.delivery TO ROLE dashboard_viewer;
GRANT SELECT ON FUTURE TABLES IN SCHEMA f1_db.delivery TO ROLE dashboard_viewer;


--Check if the role works
GRANT ROLE dashboard_viewer TO USER cobra;
