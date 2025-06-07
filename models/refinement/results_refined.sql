SELECT res.*, st.status 
FROM
    {{ ref('results_stg') }} AS res 
JOIN
    {{ ref('status_mapping') }} AS st
ON
    res.StatusID = st.StatusID 
WHERE
    
    res.POSITION IN (1, 2, 3)