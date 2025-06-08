# Setting Environment and importing libraries

import fastf1
import pandas as pd
import os
os.makedirs('f1_cache', exist_ok=True)
fastf1.Cache.enable_cache('f1_cache')

# Because of the amount of data that cause crashing the cache, each year was processed separately.

# Fetching Weather data 
year = 2022  # Change this for other years
weather_20 = []

for round_number in range(1, 25):  # Most seasons have up to 24 races
    try:
        session = fastf1.get_session(year, round_number, 'Race')
        session.load(weather=True)

        event = session.event
        weather_df = session.weather_data.copy()

        # Add contextual info
        weather_df['Year'] = year
        weather_df['EventName'] = event['EventName']
        weather_df['RoundNumber'] = event['RoundNumber']
        weather_df['Country'] = event['Country']
        weather_df['Date'] = event['EventDate'].date()

        weather_20.append(weather_df)
        print(f"✅ Collected weather for {year} - {event['EventName']}")

    except Exception as e:
        print(f"⚠️ Failed to process weather for {year} Round {round_number}: {e}")

# Combine all race sessions into one DataFrame
weather_20 = pd.concat(weather_20, ignore_index=True)

# Save to CSV
weather_20.to_csv(f"weather_{year}.csv", index=False)
print(f"✅ Saved weather data for {year} to weather_{year}.csv")

# Fetching Tyres data 
tyres_data_24 = []

year = 2024

# Loop through all potential race rounds
for round_number in range(1, 24):  # Adjust if fewer rounds confirmed
    try:
        session = fastf1.get_session(year, round_number, 'Race')
        session.load(laps=True)

        event = session.event
        laps = session.laps

        # Append lap data
        for _, lap in laps.iterrows():
            tyres_data_24.append({
                "Year": year,
                "EventName": event['EventName'],
                "RoundNumber": event['RoundNumber'],
                "Country": event['Country'],
                "Date": event['EventDate'].date(),
                "Driver": lap['Driver'],
                "LapNumber": lap['LapNumber'],
                "Stint": lap['Stint'],
                "Compound": lap['Compound'],
                "TyreLife": lap['TyreLife'],
                "FreshTyre": lap['FreshTyre']
            })

        print(f"✅ Processed {year} - {event['EventName']}")

    except Exception as e:
        print(f"⚠️ Failed to process {year} Round {round_number}: {e}")

# Create DataFrame
tyres_24 = pd.DataFrame(tyres_data_24)

# Save to CSV
tyres_24.to_csv('tyres_24.csv', index=False)

print("✅ Saved to tyres_24.csv")