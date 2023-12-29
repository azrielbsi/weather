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
feels_like_kelvin=$(echo $weather_info | jq -r '.main.feels_like')
feels_like_celsius=$(kelvin_to_celsius $feels_like_kelvin)
pressure=$(echo $weather_info | jq -r '.main.pressure')
visibility=$(echo $weather_info | jq -r '.visibility')
wind_deg=$(echo $weather_info | jq -r '.wind.deg')

temp_min_celsius=$(kelvin_to_celsius $temp_min_kelvin)
temp_max_celsius=$(kelvin_to_celsius $temp_max_kelvin)

weather_icon=$(echo $weather_info | jq -r '.weather[0].icon')
icon_url="https://openweathermap.org/img/w/${weather_icon}.png"
clouds=$(echo $weather_info | jq -r '.clouds.all')
sunrise_unix=$(echo $weather_info | jq -r '.sys.sunrise')
sunset_unix=$(echo $weather_info | jq -r '.sys.sunset')
sunrise_readable=$(date -d @$sunrise_unix +'%Y-%m-%d %H:%M:%S')
sunset_readable=$(date -d @$sunset_unix +'%Y-%m-%d %H:%M:%S')

echo "# <h1 align="center"><img height="40" src="images/cloud.png"> Daily Weather <img height="40" src="images/cloud.png"></h1>" > README.md
echo -e "<h3 align="center">🕒 Indonesian Time(UTC +07:00): <u>$time</u> (🤖Automated)</h3>\n" >> README.md
echo -e "<table align="center">" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td align="center"><b>${city}</b><br><img src="images/thermometer.png" height="18"> <b>${temperature_celsius}°C</b><br><img src='${icon_url}' height='40'><br><b>$condition</b><br>Feels Like: ${feels_like_celsius}°C</td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<td>" >> README.md
echo -e "<table>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td><img src="images/fast.png" height="18"> Minimum Temperature: <b>${temp_min_celsius}°C</b></td>" >> README.md
echo -e "<td><img src="images/fast.png" height="18"> Maximum Temperature: <b>${temp_max_celsius}°C</b></td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td><img src="images/humidity.png" height="18"> Humidity: <b>${humidity}%</b></td>" >> README.md
echo -e "<td><img src="images/air-flow.png" height="18"> Wind Speed: <b>${wind_speed} m/s</b></td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td>Pressure: ${pressure} hPa</td>" >> README.md
echo -e "<td>Wind Direction: ${wind_deg}°</td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td>Visibility: ${visibility} meters</td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td>Cloudiness: ${clouds}%</td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td>Sunrise: ${sunrise_readable}</td>" >> README.md
echo -e "<td>Sunset: ${sunset_readable}</td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "</table>" >> README.md
echo -e "</table>" >> README.md

git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"

git add README.md
git commit -m "🐙Update README with dynamic content"
git pull origin main

git push origin main
