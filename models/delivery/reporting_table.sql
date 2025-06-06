-- setting the context for the session
USE ROLE GRIZZLY_ROLE;
USE DATABASE F1_DB;

-- creating the DASHBOARD table in the DELIVERY schema
CREATE OR REPLACE TABLE F1_DB.DELIVERY.DASHBOARD AS

-- getting the most common tyre compound for each driver
WITH driver_most_common_compound AS (
    SELECT
        RACEID,
        DRIVERID,
        MODE(COMPOUND) AS most_common_compound
    FROM
        F1_DB.REFINEMENT.TYRES_REFINED
    GROUP BY
        RACEID,
        DRIVERID
),
-- getting the fastest lap time for each race in minutes
fastest_lap_times AS (
    SELECT
        RACEID_KEY,
        MIN((3600*HOUR(TIME) + 60*MINUTE(TIME) + SECOND(TIME))/60) AS fastest_lap_time_minutes
    FROM
        F1_DB.REFINEMENT.LAP_TIMES_REFINED
    GROUP BY
        RACEID_KEY
),
-- getting the average lap time for each race in minutes
average_lap_times AS (
    SELECT
        RACEID_KEY,
        AVG((3600*HOUR(TIME) + 60*MINUTE(TIME) + SECOND(TIME))/60) AS avg_lap_time_minutes
    FROM
        F1_DB.REFINEMENT.LAP_TIMES_REFINED
    GROUP BY
        RACEID_KEY
)
-- selecting columns for dashboard 
SELECT
    r.YEAR,
    r.NAME,
    c.LOCATION,
    c.COUNTRY,
    ROUND(w.AIRTEMP, 2) AS AIRTEMP,
    ROUND(w.HUMIDITY, 2) AS HUMIDITY,
    ROUND(w.PRESSURE, 2) AS PRESSURE,
    ROUND(w.RAINFALL, 2) AS RAINFALL,
    ROUND(w.TRACKTEMP, 2) AS TRACKTEMP,
    ROUND(w.WINDDIRECTION, 2) AS WINDDIRECTION,
    ROUND(w.WINDSPEED, 2) AS WINDSPEED,
    d.FORENAME || ' ' || d.SURNAME AS WINNER_NAME,
    d.NATIONALITY AS WINNER_NATIONALITY,
    mcc.most_common_compound,
    ROUND(flt.fastest_lap_time_minutes, 4) AS RACE_FASTEST_LAP_MINUTES,
    ROUND(alt.avg_lap_time_minutes, 4) AS RACE_AVG_LAP_TIME_MINUTES
FROM
    F1_DB.REFINEMENT.RACES_REFINED r
-- joining tables to get the required columns
JOIN
    F1_DB.REFINEMENT.CURCUITS_REFINED c ON r.CIRCUITID = c.CIRCUITID
JOIN
    F1_DB.REFINEMENT.WEATHER_REFINED w ON r.RACEID = w.RACEID
JOIN
    F1_DB.REFINEMENT.RESULTS_REFINED rr ON r.RACEID = rr.RACEID
JOIN
    F1_DB.REFINEMENT.DRIVERS_REFINED d ON rr.DRIVERID = d.DRIVERID
LEFT JOIN
    driver_most_common_compound mcc ON r.RACEID = mcc.RACEID AND rr.DRIVERID = mcc.DRIVERID
LEFT JOIN
    fastest_lap_times flt ON CAST(r.RACEID AS VARCHAR) = flt.RACEID_KEY
LEFT JOIN
    average_lap_times alt ON CAST(r.RACEID AS VARCHAR) = alt.RACEID_KEY
WHERE rr.POSITION = 1;
