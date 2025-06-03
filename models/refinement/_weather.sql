WITH weather AS (
    SELECT *
    FROM {{ ref('_weather_20_24') }} AS w
        LEFT JOIN {{ ref('_weather_cities') }} AS c
        ON w.country = c.country_cities
)
-- connecting year, roundnumber to races table to get raceid as a key to create relation to kaggle dataset
SELECT DISTINCT weather.*,
    races.raceid
FROM weather
    LEFT JOIN {{ source('F1_rawdata', 'races') }} AS races
    ON weather.year = races.year
    AND weather.roundnumber = races.round
