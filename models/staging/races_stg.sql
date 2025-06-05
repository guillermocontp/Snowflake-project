SELECT RaceID, Year, Round, CircuitID, Name
FROM {{ source('F1_rawdata', 'races') }}