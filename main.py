import requests
import os

def get_weather(api_key, city):
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}"
    response = requests.get(url)
    data = response.json()
    return data

def main():
    api_key = os.environ.get("OPENWEATHERMAP_API_KEY")
    city = "depok"  # Ganti dengan nama kota yang ingin Anda pantau cuacanya

    weather_data = get_weather(api_key, city)

    # Proses data cuaca sesuai kebutuhan Anda
    # Misalnya, ekstrak suhu, kelembaban, dll.

    # Tulis data ke README.md
    with open("README.md", "w") as readme:
        readme.write("# Daily Weather\n\n")
        # Tulis data cuaca ke README.md

if __name__ == "__main__":
    main()
