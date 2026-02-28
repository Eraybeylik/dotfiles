#!/bin/bash

# Check network status
if ! nm-online -q -t 1; then
    echo '{"text":"󰖪","class":"disconnected","tooltip":"Disconnected"}'
    exit
fi

# Get connection info
CONNECTION=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | head -n1)
NAME=$(echo "$CONNECTION" | cut -d: -f1)
TYPE=$(echo "$CONNECTION" | cut -d: -f2)

# Get WiFi info
if [[ "$TYPE" == "802-11-wireless" ]]; then
    SIGNAL=$(nmcli -t -f IN-USE,SIGNAL device wifi | grep '^\*' | cut -d: -f2)
    
    if [ "$SIGNAL" -gt 75 ]; then
        ICON="󰤨"
    elif [ "$SIGNAL" -gt 50 ]; then
        ICON="󰤥"
    elif [ "$SIGNAL" -gt 25 ]; then
        ICON="󰤢"
    else
        ICON="󰤟"
    fi
    
    echo "{\"text\":\"$ICON $NAME\",\"class\":\"connected\",\"tooltip\":\"Signal: $SIGNAL%\"}"
elif [[ "$TYPE" == "802-3-ethernet" ]]; then
    echo "{\"text\":\"󰈀 $NAME\",\"class\":\"connected\",\"tooltip\":\"Ethernet Connected\"}"
else
    echo "{\"text\":\"󰖪\",\"class\":\"disconnected\",\"tooltip\":\"Unknown Connection\"}"
fi
