SELECT RaceID_key, DriverID, Lap, Position, Time, milliseconds,
FROM {{ source('F1_rawdata', 'lap_times') }} 