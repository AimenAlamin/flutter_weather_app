import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/atmosphere.dart';
import 'package:weather_app/card_forecast_design.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Nicosia,CY";
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=1bf472cd9e7e6ce4f793cda5928abe9c",
        ),
      );
      final weatherdata = jsonDecode(res.body);
      if (weatherdata["cod"] != '200') {
        throw 'An unexpected error occurred';
        //or throw data['message']; /this will display error message that comes from API
      }
      return weatherdata;
    } catch (err) {
      throw err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        //wrap the body with futurebuilder
        future: getCurrentWeather(), // here I'm calling my future function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //while waiting display CircularProgressIndicator and make it adaptive to screen environment
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            ); //snapshot.error is an object so we typcast it
          }
          final thedata = snapshot.data!; //here we saying the data is not null
          //current weather data
          final currentWeatherData = thedata['list'][0];
          //convert the kelvin to celsius
          final currentTemp = currentWeatherData['main']['temp'] - 273.15;
          final inCelsius = currentTemp.toStringAsFixed(0);
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final time = DateTime.parse(currentWeatherData["dt_txt"]);
          IconData iconData;
          if (time.hour < 6 || time.hour >= 18) {
            // Night time
            iconData = Icons.nightlight_round_outlined;
          } else {
            // Day time
            iconData = Icons.sunny;
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //display weather(Main Card)
                SizedBox(
                  width: double.infinity,
                  //
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    //
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                "Nicosia",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Text(
                                "$inCelsius °c",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Icon(
                                currentSky == "Clouds" || currentSky == "Rain"
                                    ? Icons.cloud
                                    : iconData,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                currentSky == "Clouds" || currentSky == "Rain"
                                    ? "Clouds"
                                    : iconData == Icons.sunny
                                        ? "Sunny"
                                        : "Clear",
                                style: const TextStyle(fontSize: 23),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //Hourly weather forecast
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                // wrap it in listview builder and iterate 8 times
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    itemCount: 8,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final nextWeatherData = thedata['list'][index + 1];
                      //convert the kelvin to celsius
                      final nextTemp = nextWeatherData['main']['temp'] - 273.15;
                      final nextInCelsius = nextTemp.toStringAsFixed(0);
                      final nextSky = nextWeatherData["weather"][0]["main"];
                      final time = DateTime.parse(nextWeatherData["dt_txt"]);
                      IconData iconData;
                      if (time.hour < 6 || time.hour >= 18) {
                        // Night time
                        iconData = Icons.nightlight_round_outlined;
                      } else {
                        // Day time
                        iconData = Icons.sunny;
                      }
                      return CardForecast(
                        time: DateFormat.j().format(time),
                        icon: nextSky == "Clouds" || nextSky == 'Rain'
                            ? Icons.cloud
                            : iconData,
                        temperature: "$nextInCelsius °C",
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //additional information
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 11,
                ),
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Atmosphere(
                        atmoIcon: Icons.water_drop,
                        atmoText: "Humidity",
                        atmoNumber: currentHumidity.toString()),
                    Atmosphere(
                        atmoIcon: Icons.air,
                        atmoText: "Wind Speed",
                        atmoNumber: currentWindSpeed.toString()),
                    Atmosphere(
                        atmoIcon: Icons.beach_access,
                        atmoText: "Pressure",
                        atmoNumber: currentPressure.toString()),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
