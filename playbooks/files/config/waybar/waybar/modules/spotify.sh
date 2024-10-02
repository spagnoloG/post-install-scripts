#!/bin/sh

class=$(playerctl metadata --player=spotify --format '{{lc(status)}}')
icon="  "

if [[ $class == "playing" ]]; then
  info=$(playerctl metadata --player=spotify --format '{{artist}} - {{title}}')
  info=$(echo $info | cut -c1-50)
  text=$icon"  "$info
elif [[ $class == "paused" ]]; then
  text=$icon"  "paused
elif [[ $class == "stopped" ]]; then
  text=""
fi

echo -e "{\"text\":\""$text"\", \"class\":\""$class"\"}"
