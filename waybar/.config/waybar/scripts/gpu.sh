#!/usr/bin/env bash
# Waybar: NVIDIA dGPU usage/temp. Reads runtime PM state first so polling
# never wakes a suspended dGPU (nvidia-smi would).

dev="$(lspci -D -d 10de: 2>/dev/null | awk '/VGA|3D/ {print $1; exit}')"
status="$(cat "/sys/bus/pci/devices/$dev/power/runtime_status" 2>/dev/null)"

if [[ -z "$dev" || "$status" == "suspended" ]]; then
  echo '{"text":"󰢮 off","tooltip":"dGPU asleep","class":"off"}'
  exit
fi

IFS=', ' read -r util temp mem_used mem_total name < <(
  nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total,name \
    --format=csv,noheader,nounits 2>/dev/null
)

[[ -z "$util" ]] && { echo '{"text":"󰢮 ?","tooltip":"nvidia-smi failed","class":"off"}'; exit; }

class="active"; ((temp >= 80)) && class="hot"
printf '{"text":"󰢮 %s%%","tooltip":"%s\\nUsage: %s%%  Temp: %s°C\\nVRAM: %s / %s MiB","class":"%s"}\n' \
  "$util" "$name" "$util" "$temp" "$mem_used" "$mem_total" "$class"
