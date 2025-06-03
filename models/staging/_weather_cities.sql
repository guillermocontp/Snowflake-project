SELECT *,
    --creatign column with a country name for further conenction to weather_20_24
    CASE cityname
        WHEN 'Los Angeles' THEN 'USA'
        WHEN 'Mexico City' THEN 'Mexico'
        WHEN 'London' THEN 'UK'
        WHEN 'Amsterdam' THEN 'Netherlands'
        WHEN 'Istanbul' THEN 'Turkey'
        WHEN 'Tokyo' THEN 'Japan'
        WHEN 'Paris' THEN 'France'
        WHEN 'Singapore' THEN 'Singapore'
        WHEN 'Berlin' THEN 'Germany'
        WHEN 'Shanghai' THEN 'China'
        WHEN 'São Paulo' THEN 'Brazil'
        ELSE 'Unknown'
      END AS country_cities
FROM {{ source('F1_rawdata', 'weather_cities') }}
WHERE cityname IN ('Los Angeles','Mexico City','London','Amsterdam','Istanbul','Tokyo','Paris','Singapore','Berlin','Shanghai','São Paulo ')