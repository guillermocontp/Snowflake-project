SELECT
    t.*, 
    r.raceid,
    d.driverid AS driverid,
FROM {{ ref('_tyres_only') }} AS t
    LEFT JOIN {{ source('F1_rawdata', 'drivers') }} AS d
    ON t.driver = d.code
--only "active" drivers have their numebrs
    LEFT JOIN {{ source('F1_rawdata', 'races') }} AS r
    ON t.year = r.year AND 
       t.roundnumber = r.round
WHERE d.number IS NOT NULL
GROUP BY ALL   