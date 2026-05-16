#!/usr/bin/env python3
import requests
import json

def get_weather():
    try:
        response = requests.get("https://wttr.in/Istanbul?format=j1", timeout=10)
        data = response.json()

        current = data["current_condition"][0]
        temp = current["temp_C"]
        feels_like = current["FeelsLikeC"]
        desc = current["weatherDesc"][0]["value"]
        area = data["nearest_area"][0]["areaName"][0]["value"]
        country = data["nearest_area"][0]["country"][0]["value"]

        weather_icons = {
            "Sunny": "󰖙",
            "Clear": "󰖔",
            "Partly cloudy": "",
            "Cloudy": "",
            "Overcast": "",
            "Mist": "",
            "Fog": "",
            "Rain": "",
            "Drizzle": "",
            "Snow": "",
            "Blizzard": "",
            "Thunder": "",
            "default": ""
        }

        icon = weather_icons.get(desc, weather_icons["default"])

        output = {
            "text": f"{icon} {temp}°C",
            "alt": desc,
            "tooltip": f"{area}, {country}\n{desc}\nTemp: {temp}°C (Feels like {feels_like}°C)",
            "class": "weather"
        }
        print(json.dumps(output))
    except Exception as e:
        print(json.dumps({"text": "", "alt": "Error", "tooltip": str(e)}))

get_weather()
