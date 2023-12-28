#!/bin/bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export TZ=Asia/Jakarta

kelvin_to_celsius() {
    echo "scale=2; $1 - 273.15" | bc
}

time=$(date +'%Y-%m-%d %H:%M:%S %Z')
city="Depok"
weather_info=$(curl -s "http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${OPENWEATHERMAP_API_KEY}")

temperature_kelvin=$(echo $weather_info | jq -r '.main.temp')
temperature_celsius=$(kelvin_to_celsius $temperature_kelvin)
condition=$(echo $weather_info | jq -r '.weather[0].description')
icon_code=$(echo $weather_data | jq -r '.weather.icon')
temp_min_kelvin=$(echo $weather_info | jq -r '.main.temp_min')
temp_max_kelvin=$(echo $weather_info | jq -r '.main.temp_max')
humidity=$(echo $weather_info | jq -r '.main.humidity')
wind_speed=$(echo $weather_info | jq -r '.wind.speed')

temp_min_celsius=$(kelvin_to_celsius $temp_min_kelvin)
temp_max_celsius=$(kelvin_to_celsius $temp_max_kelvin)

icon_url="http://openweathermap.org/img/w/${icon_code}.png"

echo "[Weather](https://readme-typing-svg.demolab.com?font=Fira+Code&pause=1000&color=FFDA5D&center=true&vCenter=true&repeat=false&width=435&lines=Daily+Weather)" > README.md
echo -e "\nThis content is dynamically generated in Indonesian Time: $time\n" >> README.md
echo -e "\nCurrent Weather in $city\n\nTemperature: $temperature_celsius °C\n\nCondition: $condition\n" >> README.md
echo -e "Suhu Maksimum: ${temp_max_celsius}°C\n" >> README.md
echo -e "Suhu Minimum: ${temp_min_celsius}°C\n" >> README.md
echo -e "Kelembaban: ${humidity}%\n" >> README.md
echo -e "Kecepatan Angin: ${wind_speed} m/s\n" >> README.md

git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"

git add README.md
git commit -m "Update README with dynamic content"
git pull origin main

git push origin main
