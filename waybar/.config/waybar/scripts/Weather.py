#!/usr/bin/env python3
import requests
import json
import time

CITY = "Istanbul"

def fetch(retries=3, delay=10):
    # wttr.in often fails right after boot/login (network not up yet)
    for attempt in range(retries):
        try:
            response = requests.get(f"https://wttr.in/{CITY}?format=j1", timeout=10)
            return response.json()
        except Exception:
            if attempt == retries - 1:
                raise
            time.sleep(delay)

def get_weather():
    try:
        data = fetch()

        current = data["current_condition"][0]
        temp = current["temp_C"]
        feels_like = current["FeelsLikeC"]
        desc = current["weatherDesc"][0]["value"].strip()

        weather_icons = {
            "Sunny": "󰖙",
            "Clear": "󰖔",
            "Partly cloudy": "󰖕",
            "Cloudy": "󰖐",
            "Overcast": "󰖐",
            "Mist": "󰖑",
            "Fog": "󰖑",
            "Rain": "󰖗",
            "Drizzle": "󰖗",
            "Snow": "󰖘",
            "Blizzard": "󰼶",
            "Thunder": "󰖓",
            "default": "󰔏"
        }

        # wttr.in descriptions vary ("Patchy light rain with thunder", "Overcast "),
        # so match by keyword; order matters (thunder before rain, etc.)
        priority = ["Thunder", "Blizzard", "Snow", "Rain", "Drizzle", "Fog", "Mist",
                    "Partly cloudy", "Cloudy", "Overcast", "Sunny", "Clear"]
        icon = next((weather_icons[k] for k in priority if k.lower() in desc.lower()),
                    weather_icons["default"])

        output = {
            "text": f"{icon} {temp}°C",
            "alt": desc,
            "tooltip": f"{CITY}\n{desc}\nTemp: {temp}°C (Feels like {feels_like}°C)",
            "class": "weather"
        }
        print(json.dumps(output))
    except Exception as e:
        print(json.dumps({"text": "󰖐 --", "alt": "Error", "tooltip": f"Weather unavailable: {e}", "class": "error"}))

get_weather()
