SELECT 
    lt.RACEID_KEY,
    lt.DRIVERID,
    lt.LAP,
    lt.POSITION,
    -- convert milliseconds to TIME format
    TO_TIME(FLOOR(lt.MILLISECONDS/1000/60/60) || ':' || 
            FLOOR(MOD(lt.MILLISECONDS/1000/60, 60)) || ':' || 
            MOD(lt.MILLISECONDS/1000, 60)) AS TIME 

FROM {{ ref('lap_times_stg') }} lt
WHERE 
    EXISTS (
        -- only include drivers that appear in RESULTS_REFINED
        SELECT 1 FROM REFINEMENT.RESULTS_REFINED rr 
        WHERE lt.DRIVERID = rr.DRIVERID
    );