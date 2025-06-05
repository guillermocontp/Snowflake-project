WITH weather AS (
    SELECT 
        year,
        eventname,
        roundnumber,
        country,
        date,
        AVG(airtemp) AS airtemp,
        AVG(humidity) AS humidity,
        AVG(pressure) AS pressure,
    -- the higer number the longer it rained during race 
        SUM(CASE WHEN rainfall = FALSE THEN 0 ELSE 1 END) AS rainfall,
        AVG(tracktemp) AS tracktemp,
        AVG(winddirection) AS winddirection,
        AVG(windspeed) AS windspeed,
        c.*,
    FROM {{ ref('_weather_20_24') }} AS w
        LEFT JOIN {{ ref('_weather_cities') }} AS c
        ON w.country = c.country_cities
    GROUP BY ALL
)
-- connecting year, roundnumber to races table to get raceid as a key to create relation to kaggle dataset
SELECT DISTINCT weather.*,
    races.raceid
FROM weather 
    LEFT JOIN {{ source('F1_rawdata', 'races') }} AS races
    ON weather.year = races.year
    AND weather.roundnumber = races.round
