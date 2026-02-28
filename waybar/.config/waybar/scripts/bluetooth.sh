#!/bin/bash

# Check if bluetooth is powered on
if ! bluetoothctl show | grep -q "Powered: yes"; then
    echo '{"text":"󰂲","class":"off","tooltip":"Bluetooth Off"}'
    exit
fi

# Count connected devices
CONNECTED=$(bluetoothctl devices Connected | wc -l)

if [ "$CONNECTED" -gt 0 ]; then
    DEVICES=$(bluetoothctl devices Connected | cut -d' ' -f3- | tr '\n' ',' | sed 's/,$//')
    echo "{\"text\":\"󰂱 $CONNECTED\",\"class\":\"connected\",\"tooltip\":\"Connected: $DEVICES\"}"
else
    echo '{"text":"󰂯","class":"on","tooltip":"Bluetooth On"}'
fi
