select CircuitID, CircuitRef, Name, Location, Country
from {{ source('F1_rawdata','circuits') }}