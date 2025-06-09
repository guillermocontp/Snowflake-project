#importing
import snowflake.connector
import pandas as pd
import streamlit as st
import requests
from PIL import Image, ImageOps
from io import BytesIO

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

# Get image from wikipedia
def fetch_wikipedia_image(title):
    """
    Fetches the main image from a Wikipedia page given its title.
    Returns the image URL or None if not found.
    """
    URL = "https://en.wikipedia.org/w/api.php"
    params = {
        "action": "query",
        "format": "json",
        "titles": title,
        "prop": "pageimages",
        "pithumbsize": 400
    }
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"  # Avoid 403 errors
    }

    try:
        response = requests.get(URL, params=params, headers=headers)
        response.raise_for_status()
        pages = response.json().get("query", {}).get("pages", {})
        for page_id, page_data in pages.items():
            thumbnail = page_data.get("thumbnail", {})
            return thumbnail.get("source")
    except Exception as e:
        st.warning(f"❌ Error fetching image for '{title}': {e}")
        return None


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

# Load and convert image, add white background if needed
def load_image_with_white_bg(image_url, max_size=(400, 250)):
    response = requests.get(image_url)
    if response.status_code != 200:
        st.warning(f"Failed to fetch image: status code {response.status_code}")
        return None

    content_type = response.headers.get("Content-Type", "")
    try:
        if content_type == "image/svg+xml" or image_url.lower().endswith(".svg"):
            st.warning("SVG images are not supported in this deployment")
            return None
        else:
            img = Image.open(BytesIO(response.content))
    except Exception as e:
        st.warning(f"Failed to open image: {e}")
        return None

    img.thumbnail(max_size)

    if img.mode in ('RGBA', 'LA'):
        bg = Image.new("RGBA", img.size, (255, 255, 255, 255))
        bg.paste(img, mask=img.split()[3])
        img = bg.convert("RGB")

    return img

# Main logic
if (
    selected_year != "-- Select Year --"
    and selected_race is not None
    and selected_race != "-- Select Race --"
):
    filtered_race = data[
        (data['YEAR'] == selected_year) & (data['NAME'] == selected_race)
    ].iloc[0]

    st.subheader(f"🏁 {filtered_race['NAME']} ({selected_year}) - {filtered_race['LOCATION']}, {filtered_race['COUNTRY']}")

    # Track description and image
    track_intro = fetch_wikipedia_intro(filtered_race['NAME'])
    track_image_url = fetch_wikipedia_image(filtered_race['NAME'])
    track_img = None
    if track_image_url:
        track_img = load_image_with_white_bg(track_image_url)

    if track_intro or track_img:
        col1, col2 = st.columns([2, 3])
        if track_intro:
            col1.write(track_intro)
        if track_img:
            col2.image(track_img, caption=f"Track: {filtered_race['NAME']}", use_container_width=True)
    else:
        st.info("Track info not found.")

    # Winner section with centered image and caption
    winner_name = filtered_race['WINNER_NAME']
    winner_nationality = filtered_race['WINNER_NATIONALITY']
    winner_image_url = fetch_wikipedia_image(winner_name)

    st.markdown("<h3 style='text-align: center;'>🏆 Winner</h3>", unsafe_allow_html=True)
    if winner_image_url:
        winner_img = load_image_with_white_bg(winner_image_url, max_size=(150, 150))
        if winner_img:
            st.markdown(
                f"<div style='text-align: center;'>"
                f"<img src='{winner_image_url}' width='150'><br>"
                f"<strong>{winner_name}</strong> ({winner_nationality})"
                f"</div>",
                unsafe_allow_html=True
            )

    # Weather conditions section
    st.markdown("<h3 style='text-align: center;'>🌦️ Weather Conditions</h3>", unsafe_allow_html=True)
    col1, col2, col3 = st.columns(3)
    col1.metric("Air Temp (°C)", round(filtered_race['AIRTEMP'], 2))
    col2.metric("Track Temp (°C)", round(filtered_race['TRACKTEMP'], 2))
    col3.metric("Rainfall", filtered_race['RAINFALL'])

    col4, col5, col6 = st.columns(3)
    col4.metric("Humidity (%)", round(filtered_race['HUMIDITY'], 2))
    col5.metric("Pressure", round(filtered_race['PRESSURE'], 2))
    col6.metric("Wind Speed", round(filtered_race['WINDSPEED'], 2))

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
    st.markdown("<h3 style='text-align: center;'>🛞 Tyres</h3>", unsafe_allow_html=True)
    st.markdown(f"<p style='text-align: center; font-size: 18px; '>Most common compound: <strong>{compound}</strong></p>", unsafe_allow_html=True)
    st.markdown(f"<p style='text-align: center; font-size: 18px; '>{description}</p>", unsafe_allow_html=True)


    # Lap times section
    st.markdown("<h3 style='text-align: center;'>⏱️ Lap Times (in minutes)</h3>", unsafe_allow_html=True)
    lap_col1, lap_col2, lap_col3 = st.columns(3)
    lap_col1.metric("Fastest Lap", round(filtered_race['RACE_FASTEST_LAP_MINUTES'], 2))
    lap_col2.metric("Race Avg Lap", round(filtered_race['RACE_AVG_LAP_TIME_MINUTES'], 2))
    lap_col3.metric("Winner Avg Lap", round(filtered_race['WINNER_AVG_LAP_TIME_MINUTES'], 2))

else:
    st.info("Please select a year and a race to display dashboard.")
