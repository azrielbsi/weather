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
location=$(curl -s "https://ipinfo.io/116.206.8.2/json?token=${IPINFO_API_KEY}")
city=$(echo "$location" | jq -r '.city')
city_encoded=${city// /%20}
weather_info=$(curl -s "http://api.openweathermap.org/data/2.5/weather?q=${city_encoded}&appid=${OPENWEATHERMAP_API_KEY}")

latitude=$(echo "$weather_info" | jq -r '.coord.lat')
longitude=$(echo "$weather_info" | jq -r '.coord.lon')

weather_info=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${OPENWEATHERMAP_API_KEY}")

temperature_kelvin=$(echo "$weather_info" | jq -r '.main.temp')
temperature_celsius=$(kelvin_to_celsius $temperature_kelvin)
condition=$(echo "$weather_info" | jq -r '.weather[0].main')
condition1=$(echo "$weather_info" | jq -r '.weather[0].description')
icon_code=$(echo "$weather_info" | jq -r '.weather.icon')
temp_min_kelvin=$(echo "$weather_info" | jq -r '.main.temp_min')
temp_max_kelvin=$(echo "$weather_info" | jq -r '.main.temp_max')
humidity=$(echo "$weather_info" | jq -r '.main.humidity')
feels_like_kelvin=$(echo "$weather_info" | jq -r '.main.feels_like')
feels_like_celsius=$(kelvin_to_celsius $feels_like_kelvin)
pressure=$(echo "$weather_info" | jq -r '.main.pressure')
visibility=$(echo "$weather_info" | jq -r '.visibility')
wind_deg=$(echo "$weather_info" | jq -r '.wind.deg')
gust_speed=$(echo "$weather_info" | jq -r '.wind.gust // empty')
wind_speed=$(echo $weather_info | jq -r '.wind.speed // empty')
rainfall=$(echo "$weather_info" | jq -r '.rain."1h"')
rainfall_mm=$(echo "scale=2; $rainfall * 25.4" | bc)

temp_min_celsius=$(kelvin_to_celsius ${temp_min_kelvin:-0})
temp_max_celsius=$(kelvin_to_celsius ${temp_max_kelvin:-0})

weather_icon=$(echo "$weather_info" | jq -r '.weather[0].icon')
icon_url="https://openweathermap.org/img/w/${weather_icon}.png"
clouds=$(echo "$weather_info" | jq -r '.clouds.all')
sunrise_unix=$(echo "$weather_info" | jq -r '.sys.sunrise')
sunset_unix=$(echo "$weather_info" | jq -r '.sys.sunset')
sunrise_readable=$(date -d @$sunrise_unix +'%Y-%m-%d %H:%M:%S')
sunset_readable=$(date -d @$sunset_unix +'%Y-%m-%d %H:%M:%S')
timezone=$(echo "$weather_info" | jq -r '.timezone')
coord_lon=$(echo "$weather_info" | jq -r '.coord.lon')
coord_lat=$(echo "$weather_info" | jq -r '.coord.lat')
wind_direction=$(echo "$weather_info" | jq -r '.wind.deg')
wind_direction_text() {
    local degree=$1

    if (( $degree >= 348.75 || $degree < 11.25 )); then
        echo "North"
    elif (( $degree >= 11.25 && $degree < 33.75 )); then
        echo "North-Northeast"
    elif (( $degree >= 33.75 && $degree < 56.25 )); then
        echo "Northeast"
    elif (( $degree >= 56.25 && $degree < 78.75 )); then
        echo "East-Northeast"
    elif (( $degree >= 78.75 && $degree < 101.25 )); then
        echo "East"
    elif (( $degree >= 101.25 && $degree < 123.75 )); then
        echo "East-Southeast"
    elif (( $degree >= 123.75 && $degree < 146.25 )); then
        echo "Southeast"
    elif (( $degree >= 146.25 && $degree < 168.75 )); then
        echo "South-Southeast"
    elif (( $degree >= 168.75 && $degree < 191.25 )); then
        echo "South"
    elif (( $degree >= 191.25 && $degree < 213.75 )); then
        echo "South-Southwest"
    elif (( $degree >= 213.75 && $degree < 236.25 )); then
        echo "Southwest"
    elif (( $degree >= 236.25 && $degree < 258.75 )); then
        echo "West-Southwest"
    elif (( $degree >= 258.75 && $degree < 281.25 )); then
        echo "West"
    elif (( $degree >= 281.25 && $degree < 303.75 )); then
        echo "West-Northwest"
    elif (( $degree >= 303.75 && $degree < 326.25 )); then
        echo "Northwest"
    else
        echo "North-Northwest"
    fi
}
wind_direction_text=$(wind_direction_text $wind_direction)
weather_description_with_wind="${condition1} - Wind Direction: ${wind_direction_text:-Unknown}"
forecast_info=$(curl -s "http://api.openweathermap.org/data/2.5/forecast?q=${city_encoded}&cnt=5&appid=${OPENWEATHERMAP_API_KEY}")

echo "# <h1 align='center'><img height='40' src='images/cloud.png'> Daily Weather Report <img height='40' src='images/cloud.png'></h1>" > README.md
echo -e "<h3 align='center'>🕒 Indonesian Time(UTC$(printf "%+.2f" "$(bc <<< "scale=2; $timezone / 3600")")): <u>$time</u> (🤖Automated)</h3>\n" >> README.md
echo "<h2>5-Day Forecast</h2>" >> README.md
for ((i=0; i<5; i++)); do
    forecast_date_unix=$(echo "$forecast_info" | jq -r ".list[$i].dt")
    forecast_date_readable=$(date -d @$forecast_date_unix +'%Y-%m-%d')

    forecast_condition=$(echo "$forecast_info" | jq -r ".list[$i].weather[0].description")
    forecast_temperature_kelvin=$(echo "$forecast_info" | jq -r ".list[$i].main.temp")
    forecast_temperature_celsius=$(kelvin_to_celsius $forecast_temperature_kelvin)

    echo -e "<h3>$forecast_date_readable</h3>" >> README.md
    echo -e "<p><b>Condition:</b> $forecast_condition</p>" >> README.md
    echo -e "<p><b>Temperature:</b> ${forecast_temperature_celsius:-0}°C</p>" >> README.md
    echo -e "<hr>" >> README.md
done
echo -e "<table align='center'>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td align='center'><img src='images/placeholder.png' height='18'> <b>${city}</b><br><b>Latitude: ${coord_lat:-0} Longitude: ${coord_lon:-0}</b><br><img src='images/thermometer.png' height='18'> <b>${temperature_celsius:-0}°C</b><br><img src='${icon_url}' height='50'><br><b>$condition</b><br><b>($condition1)</b><br><b>Feels Like: ${feels_like_celsius:-0}°C ${weather_description_with_wind}</b></td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<td>" >> README.md
echo -e "<table>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td align="center" colspan="2"><img src="images/rain.png" height="25"><br>Rainfall: <b>${rainfall_mm:-0} Millimeters</b></td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td align='center'><img src='images/fast.png' height='25'><br>Minimum<br>Temperature:<br><b>${temp_min_celsius:-0}°C</b></td>" >> README.md
echo -e "<td align='center'><img src='images/fast.png' height='25'><br>Maximum<br>Temperature:<br><b>${temp_max_celsius:-0}°C</b></td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td align='center'><img src='images/humidity.png' height='25'><br>Humidity:<br><b>${humidity:-0}%</b></td>" >> README.md
echo -e "<td align='center'><img src='images/atmospheric.png' height='25'><br>Atmospheric<br>Pressure:<br><b>${pressure:-0} hPa</b></td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td align='center'><img src='images/air-flow.png' height='25'><br>Wind Speed:<br><b>${wind_speed:-0} m/s</b><br>Wind Gust Speed:<br><b>${gust_speed:-0} m/s</b></td>" >> README.md
echo -e "<td align='center'><img src='images/anemometer.png' height='25'><br>Wind Direction:<br><b>${wind_deg:-0}°</b></td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td align='center'><img src='images/cloudy.png' height='25'><br>Cloudiness:<br><b>${clouds:-0}%</b></td>" >> README.md
echo -e "<td align='center'><img src='images/low-visibility.png' height='25'><br>Visibility:<br><b>${visibility:-0} Meters</b></td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "<tr>" >> README.md
echo -e "<td align='center'><img src='images/sunrise.png' height='25'><br>Sunrise:<br><b>${sunrise_readable:-0}</b></td>" >> README.md
echo -e "<td align='center'><img src='images/sunsets.png' height='25'><br>Sunset:<br><b>${sunset_readable:-0}</b></td>" >> README.md
echo -e "</tr>" >> README.md
echo -e "</table>" >> README.md
echo -e "</table>" >> README.md

git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"

git add README.md
git commit -m "🐙 Update README with dynamic content $(date +'%Y-%m-%d %H:%M:%S %Z')"
git pull origin main

git push origin main
