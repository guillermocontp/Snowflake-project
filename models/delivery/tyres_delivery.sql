SELECT DISTINCT
    tyres.year,
    tyres.eventname,
    tyres.stint,
    tyres.driver,
    tyres.driverid tyres_driver,
    results.driverid results_driver,
    results.position,
    tyres.compound,
    tyres.tyrelaps
FROM {{ ref('_tyres_refined') }} AS tyres
    INNER JOIN {{ ref('results_refined') }} AS results
    ON tyres.driverid = results.driverid AND
    tyres.raceid = results.raceid