SELECT DriverID, Number, Code, Forename, Surname, Nationality
FROM {{ source('F1_rawdata', 'drivers') }}