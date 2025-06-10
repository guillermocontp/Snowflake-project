# Snowflake-project
Formula 1 & Weather Data Pipeline on Snowflake: A Data Engineering Blueprint

This project presents a complete, production-grade data engineering workflow on Snowflake, using five years of F1 and weather data as its foundation. We guide you through the process of:

Ingesting Raw Data: Pulling in CSV, JSON, and shared-database sources into a STAGING schema.
Refining Data: Applying cleaning, type conversions, joins, and aggregations within a REFINEMENT schema.
Delivering Analytics: Exposing denormalized, analytics-ready tables in a DELIVERY schema.
A simple Streamlit dashboard (complemented by Snowsight views) allows users to easily pick any Grand Prix and year to see podium results, track-day weather, and basic performance metrics. This setup effectively showcases how Snowflake's powerful architecture, granular role-based access control, and seamless dbt integration are perfect for building scalable, secure, and robust data pipelines.

What You'll Find Here:

Layered Snowflake Design: STAGING → REFINEMENT → DELIVERY for clear data separation.
Automated Ingestion: Through Snowflake stages and Marketplace shares.
Strong RBAC Model: Ensuring secure separation between development and data consumption.
dbt-Powered Transformations: For modularity, reusability, and built-in testing.
Lightweight Analytics: Accessible via Snowsight and Streamlit.
Real-World ELT Best Practices: Demonstrated end-to-end on Snowflake.