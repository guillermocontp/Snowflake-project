# importing
import snowflake.connector
import pandas as pd
import streamlit as st
import requests
import pydeck as pdk
import json
import numpy as np
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()
# Function to get config values (works both locally and on Streamlit Cloud)
def get_config(key):
    # Try Streamlit secrets first (for cloud deployment)
    try:
       return st.secrets[key]
    except:
        # Fall back to environment variables (for local development)
        return os.getenv(key)

#config to connect SF
conn = snowflake.connector.connect(
    user=get_config('SNOWFLAKE_USER'),
    password=get_config('SNOWFLAKE_PASSWORD'),
    account=get_config('SNOWFLAKE_ACCOUNT'),
    warehouse=get_config('SNOWFLAKE_WAREHOUSE'),
    database=get_config('SNOWFLAKE_DATABASE'),
    schema=get_config('SNOWFLAKE_SCHEMA'),
    role=get_config('SNOWFLAKE_ROLE')
)
import os
st.write("**Repository Debug Info:**")
st.write(f"Current working directory: {os.getcwd()}")
st.write(f"Files in current directory: {os.listdir('.')}")
if os.path.exists('tracks'):
    st.write(f"Files in tracks folder: {os.listdir('tracks')}")
else:
    st.write("❌ tracks folder not found")
# defining functions
def display_driver_image(driver_name, width=400):
    
    # Base URL for F1 driver images
    base_url = "https://media.formula1.com/image/upload/f_auto,c_limit,q_auto,w_1320/content/dam/fom-website/drivers/2025Drivers/"
    # Extract last name and convert to lowercase
    last_name = driver_name.split()[-1].lower()
    
    # Combine base URL with driver's last name
    image_url = f"{base_url}{last_name}"
    
    # Display the image
    st.image(image_url, caption=driver_name, width=width)
    
def display_geojson_map(geojson_filename, map_width=400, map_height=400, initial_zoom=13, initial_pitch=0):
    """
    Loads a GeoJSON file and displays it as a path on a Pydeck map.

    Args:
        geojson_filename (str): The path to the GeoJSON file.
        map_width (int or str): Width of the map.
        map_height (int or str): Height of the map.
        initial_zoom (int): Initial zoom level of the map.
        initial_pitch (int): Initial pitch of the map.
    """
    try:
        with open(geojson_filename) as f:
            geojson_data = json.load(f)

        if geojson_data.get('features') and \
           len(geojson_data['features']) > 0 and \
           geojson_data['features'][0].get('geometry') and \
           geojson_data['features'][0]['geometry'].get('type') == 'LineString':
            
            coordinates = geojson_data['features'][0]['geometry']['coordinates']
            
            path_data = [coordinates] 
            path_df = pd.DataFrame({'path': path_data})

            if 'bbox' in geojson_data:
                bbox = geojson_data['bbox']

                center_lon = (bbox[0] + bbox[2]) / 2
                center_lat = (bbox[1] + bbox[3]) / 2
            elif coordinates and len(coordinates) > 0 and len(coordinates[0]) == 2: # Check if coordinates are valid
                center_lon = coordinates[0][0]
                center_lat = coordinates[0][1]
            else:
                st.error(f"Could not determine center for map from GeoJSON: {geojson_filename}")
                return


            initial_view_state = pdk.ViewState(
                latitude=center_lat,
                longitude=center_lon,
                zoom=initial_zoom,
                pitch=initial_pitch, 
            )

            path_layer = pdk.Layer(
                'PathLayer',
                data=path_df,
                get_path='path',
                get_color='[255, 0, 0]',  # Red color
                width_min_pixels=2,
            )

            st.pydeck_chart(pdk.Deck(
                map_style='mapbox://styles/mapbox/light-v9',
                initial_view_state=initial_view_state,
                layers=[path_layer],
                width=map_width, 
                height=map_height,   
            ))
        else:
            st.write(f"Could not find LineString coordinates in GeoJSON '{geojson_filename}' or the structure is not as expected.")
    except FileNotFoundError:
        st.error(f"Error: GeoJSON file not found at '{geojson_filename}'")
    except Exception as e:
        st.error(f"An error occurred while processing '{geojson_filename}': {e}")


def run_query(query):
    with conn.cursor() as cur:
        cur.execute(query)
        return cur.fetch_pandas_all()

st.set_page_config(page_title="Snowflake F1 Dashboard", layout="wide")
st.title("Snowflake F1 Dashboard 🏎️🏁🏆")

# Load race data from Snowflake
query = "SELECT * FROM DELIVERY.DASHBOARD"
data = run_query(query)

# Sidebar filters
st.sidebar.header("Filters")
years = sorted(data['YEAR'].dropna().unique())
selected_year = st.sidebar.selectbox("Select Year", ["-- Select Year --"] + years)

if selected_year != "-- Select Year --":
    races = sorted(data[data['YEAR'] == selected_year]['NAME'].dropna().unique())
    selected_race = st.sidebar.selectbox("Select Race", ["-- Select Race --"] + races)
else:
    selected_race = None

# Get first paragraph from wikipedia
def fetch_wikipedia_intro(title):
    URL = "https://en.wikipedia.org/api/rest_v1/page/summary/" + title
    response = requests.get(URL)
    if response.status_code == 200:
        data = response.json()
        extract = data.get("extract", "")
        first_paragraph = extract.split('\n')[0]
        return first_paragraph
    return None

# Main logic
if (
    selected_year != "-- Select Year --"
    and selected_race is not None
    and selected_race != "-- Select Race --"
):
    filtered_race = data[
        (data['YEAR'] == selected_year) & (data['NAME'] == selected_race)
    ].iloc[0]
    
    st.markdown("<br>", unsafe_allow_html=True)
    st.subheader(f"🏁 {filtered_race['NAME']} ({selected_year}) - {filtered_race['LOCATION']}, {filtered_race['COUNTRY']}")

    # Track description and image
    track_intro = fetch_wikipedia_intro(filtered_race['NAME'])
    col_track_info, col_track_map = st.columns([1, 1], gap="large") 
    
    with col_track_info:
        col_track_info.write(track_intro)

    with col_track_map:
        name_for_json = filtered_race['NAME']
        geojson_file_path = f'tracks/{name_for_json}.geojson' 
        display_geojson_map(geojson_file_path)

    # Winner section with centered image and caption
    winner_name = filtered_race['WINNER_NAME']
    winner_nationality = filtered_race['WINNER_NATIONALITY']
    
    st.markdown("<br>", unsafe_allow_html=True)
    st.markdown("<br>", unsafe_allow_html=True)
    st.markdown("<h3 style='text-align: left;'>🏆 Winner</h3>", unsafe_allow_html=True)
    
    # creating two columns for the winner's image and details
    col_winner_img, col_winner_details = st.columns([1, 2]) 

    with col_winner_img:
        display_driver_image(winner_name, width=300) # Call the modified function, adjust width as needed 
        
    with col_winner_details:
            st.markdown(f"<p style='text-align: left; font-size: 18px; '>Winner name: <strong>{winner_name}</strong></p>", unsafe_allow_html=True)
            st.markdown(f"<p style='text-align: left; font-size: 18px; '>Winner nationality: <strong>{winner_nationality}<strong></p>", unsafe_allow_html=True)

    # Weather conditions section
    st.markdown("<br>", unsafe_allow_html=True)
    st.markdown("<br>", unsafe_allow_html=True)
    st.markdown("<h3 style='text-align: left;'>🌦️ Weather Conditions</h3>", unsafe_allow_html=True)
    col1, col2, col3 = st.columns(3)
    col1.metric("Air Temp (°C)", round(filtered_race['AIRTEMP'], 2))
    col2.metric("Track Temp (°C)", round(filtered_race['TRACKTEMP'], 2))
    col3.metric("Rainfall (mm)", filtered_race['RAINFALL'])

    col4, col5, col6 = st.columns(3)
    col4.metric("Humidity (%)", round(filtered_race['HUMIDITY'], 2))
    col5.metric("Pressure (hPa)", round(filtered_race['PRESSURE'], 2))
    col6.metric("Wind Speed (km/h)", round(filtered_race['WINDSPEED'], 2))

  # Tyre descriptions dictionary
    tyre_descriptions = {
    "SOFT": "Soft tyres offer maximum grip but wear out quickly. Best for qualifying or short stints.",
    "MEDIUM": "Medium tyres balance durability and performance. Often the preferred race compound.",
    "HARD": "Hard tyres last longer but offer less grip. Useful for long stints or high degradation tracks.",
    "INTERMEDIATE": "Intermediate tyres are used in light rain conditions, offering grip on a damp track.",
    "WET": "Wet tyres have deep grooves to disperse water in heavy rain, reducing aquaplaning."
    }   

    # Display tyre info centered
    compound = filtered_race['MOST_COMMON_COMPOUND']
    description = tyre_descriptions.get(compound.upper(), "No description available.")

    # Center-aligned Tyres section
    st.markdown("<br>", unsafe_allow_html=True)
    st.markdown("<br>", unsafe_allow_html=True)
    st.markdown("<h3 style='text-align: left;'>🛞 Tyres</h3>", unsafe_allow_html=True)
    st.markdown(f"<p style='text-align: left; font-size: 18px; '>Most common compound: <strong>{compound}</strong></p>", unsafe_allow_html=True)
    st.markdown(f"<p style='text-align: left; font-size: 18px; '>{description}</p>", unsafe_allow_html=True)


    # Lap times section
    st.markdown("<br>", unsafe_allow_html=True)
    st.markdown("<br>", unsafe_allow_html=True)
    st.markdown("<h3 style='text-align: left;'>⏱️ Lap Times</h3>", unsafe_allow_html=True)
    lap_col1, lap_col2, lap_col3 = st.columns(3)
    lap_col1.metric("Fastest Lap (min)", round(filtered_race['RACE_FASTEST_LAP_MINUTES'], 2))
    lap_col2.metric("Race Avg Lap (min)", round(filtered_race['RACE_AVG_LAP_TIME_MINUTES'], 2))
    lap_col3.metric("Winner Avg Lap (min)", round(filtered_race['WINNER_AVG_LAP_TIME_MINUTES'], 2))

else:
    st.info("Please select a year and a race to display dashboard.")
