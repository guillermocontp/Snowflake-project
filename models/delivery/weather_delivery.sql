SELECT 
    year,
    eventname,
    date,
    AVG(airtemp) AS airtemp,
    AVG(humidity) AS humidity,
    AVG(pressure) AS pressure,
    MAX(CASE WHEN rainfall = TRUE THEN 1 ELSE 0 END) AS rained,
    AVG(windspeed) AS windspeed
    
FROM {{ ref('_weather_refined') }}
GROUP BY ALL