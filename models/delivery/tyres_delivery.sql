SELECT DISTINCT
    tyres.year,
    tyres.eventname,
    tyres.stint,
    tyres.driver,
    tyres.driverid,
    results.driverid,
    results.position,
    tyres.compound,
    tyres.tyrelaps
FROM tyres_refined AS tyres
    INNER JOIN results_refined AS results
    ON tyres.driverid = results.driverid AND
    tyres.raceid = results.raceid;