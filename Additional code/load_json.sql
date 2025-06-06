-- setting the context for the session
USE ROLE GRIZZLY_ROLE;
USE DATABASE F1_DB;
USE SCHEMA RAW;

-- 1. creating a staging table to temporarily hold the raw JSON data.
-- each row in this table will now correspond to one line (one race's data) from the NDJSON file.
CREATE OR REPLACE TABLE raw_lap_times_json_staging (
    json_data VARIANT
);

-- 2. copying the NDJSON data from your stage into the staging table.
-- using the new NDJSON file name. Snowflake's JSON file type handles NDJSON.
COPY INTO raw_lap_times_json_staging
FROM @MUHAMMAD_STAGE/lap_times_nd.json 
FILE_FORMAT = (TYPE = 'JSON');

-- 3. creating the target table 'lap_times' in the 'RAW' schema.
-- raceId_from_record might be redundant if raceId_from_key is sufficient and accurate.
CREATE OR REPLACE TABLE lap_times (
    raceId_key VARCHAR, 
    driverId NUMBER,
    lap NUMBER,
    position NUMBER,
    time VARCHAR,
    milliseconds NUMBER,
    original_raceId_in_lap_record NUMBER -- storing raceId from within the lap record for verification
);

-- 4. parsing the JSON from the staging table and insert it into the 'lap_times' table.
-- each row in 'raw_lap_times_json_staging' now contains an object like {"race_id_key": "X", "laps": [...]}.
INSERT INTO lap_times (raceId_key, driverId, lap, position, time, milliseconds, original_raceId_in_lap_record)
SELECT
    stg.json_data:race_id_key::VARCHAR AS raceId_key,
    lap_record.VALUE:driverId::NUMBER AS driverId,
    lap_record.VALUE:lap::NUMBER AS lap,
    lap_record.VALUE:position::NUMBER AS position,
    lap_record.VALUE:time::VARCHAR AS time,
    lap_record.VALUE:milliseconds::NUMBER AS milliseconds,
    lap_record.VALUE:raceId::NUMBER AS original_raceId_in_lap_record -- extracting from the nested lap record
FROM
    raw_lap_times_json_staging stg,
    LATERAL FLATTEN(input => stg.json_data:laps) lap_record; -- flattening the "laps" array within each JSON object