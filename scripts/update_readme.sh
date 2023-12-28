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

echo "# My Project" > README.md
echo -e "\nThis content is dynamically generated in Indonesian Time (IST): $time\n" >> README.md
echo -e "\nCurrent Weather in $city:\nTemperature: $temperature_celsius °C\nCondition: $condition" >> README.md

git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"

git add README.md
git commit -m "Update README with dynamic content"
git pull origin main

git push origin main
