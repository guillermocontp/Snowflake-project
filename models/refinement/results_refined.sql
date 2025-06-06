SELECT res.*, st.status 
FROM
    {{ ref('results_stg') }} AS res  -- Use ref() to refer to another dbt model
JOIN
    {{ ref('status_mapping') }} AS st
ON
    res.StatusID = st.StatusID 
WHERE
    races.YEAR BETWEEN 2020 AND 2025
    AND r.POSITION IN (1, 2, 3);