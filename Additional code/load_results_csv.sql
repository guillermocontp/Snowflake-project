-- setting the context for the session

USE DATABASE F1_DB;
USE SCHEMA RAW;

-- 1. creating the target table 'results' in the 'RAW' schema.
CREATE OR REPLACE TABLE results (
    resultId NUMBER,
    raceId NUMBER,
    driverId NUMBER,
    constructorId NUMBER,
    number NUMBER,
    grid NUMBER,
    position NUMBER,
    positionText VARCHAR,
    positionOrder NUMBER,
    points FLOAT,
    laps NUMBER,
    time VARCHAR,
    milliseconds NUMBER,
    fastestLap NUMBER,
    rank NUMBER,
    fastestLapTime VARCHAR,
    fastestLapSpeed FLOAT,
    statusId NUMBER
);

-- 2. copying the CSV data from your stage into the 'results' table.
COPY INTO results
FROM @MUHAMMAD_STAGE/results.csv
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_DELIMITER = ',',
    SKIP_HEADER = 1,
    NULL_IF = ('\\N'),
    EMPTY_FIELD_AS_NULL = TRUE,
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' -- adding this line to handle quoted values
);