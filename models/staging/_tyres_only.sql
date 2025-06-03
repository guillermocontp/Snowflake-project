SELECT 
    year,
    eventname,
    date,
    roundnumber,
    country,
    driver,
    stint,
    compound,
    MAX(tyrelife) AS tyrelaps
FROM {{ source('F1_rawdata', 'tyres') }}
GROUP BY ALL