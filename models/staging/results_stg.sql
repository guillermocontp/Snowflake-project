SELECT ResultID, RaceID, DriverID, Number, Grid, Position, Laps,
        Fastestlap, Fastestlaptime, Fastestlapspeed, StatusID
FROM {{ source('F1_rawdata', 'results') }}