SELECT RaceID_key, DriverID, Lap, Position, Time,
FROM {{ source('F1_rawdata', 'lap_times') }} 