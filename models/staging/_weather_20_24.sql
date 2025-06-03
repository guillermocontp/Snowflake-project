SELECT
    year,
    eventname,
    roundnumber,
    country,
    date,
    airtemp,
    humidity,
    pressure,
    rainfall,
    tracktemp,
    winddirection,
    windspeed
FROM {{ source('F1_rawdata', 'weather_20_24') }}
