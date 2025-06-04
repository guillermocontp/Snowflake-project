SELECT res.*, st.status 
FROM
    {{ ref('results_stg') }} AS res  -- Use ref() to refer to another dbt model
JOIN
    {{ ref('status_mapping') }} AS st
ON
    res.StatusID = st.StatusID 