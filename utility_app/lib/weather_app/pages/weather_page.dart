import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:utility_app/pages/homepage.dart';
import 'package:utility_app/theme/theme_provider.dart';
import 'package:utility_app/weather_app/models/weather_model.dart';
import 'package:utility_app/weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API KEY
  final _weatherService =
      WeatherService(apiKey: '523d4b53aabf6cd465ad5bcedc5c67fb');
  Weather? _weather;
  final TextEditingController textController = TextEditingController();

  // Search Weather
  void searchWeather() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Enter Text",
                  hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                )
              ),
              actions: [
                // Search Button
                MaterialButton(
                  onPressed: () async {
                    // Get the City Name
                    String newCityName = textController.text;

                    // Replace the weather
                    // Get Weather for the City
                    try {
                      final weather =
                          await _weatherService.getWeather(newCityName);
                      setState(() {
                        _weather = weather;
                      });
                    } catch (e) {
                      print(e);
                    }

                    // Pop Box
                    Navigator.pop(context);

                    // Clear Controller
                    textController.clear();
                  },
                  child: Text(
                    "Search",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),),
                ),
                // Cancel Button
                MaterialButton(
                  onPressed: () {
                    // Pop Box
                    Navigator.pop(context);

                    // Clear Controller
                    textController.clear();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                )
              ],
            ));
  }

  // Fetch Weather
  _fetchWeather() async {
    // Get the Current City
    String cityName = await _weatherService.getCurrentCity();

    // Get Weather for the City
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // Weather Animations
  String getWeatherAnimation(String? mainCondition) {
    // Default to Sunny
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
      case 'dust':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorms':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // Initial State
  @override
  void initState() {
    super.initState();

    // Fetch Weather on Startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check your Weather!🌡️",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.inversePrimary,
            )),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              const SizedBox(
                  height: 20), // Add spacing between "Home" and CupertinoSwitch
              CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            // City Name
            Text(
              _weather?.cityName ?? "Loading City...",
              style: TextStyle(
                fontSize: 40.0,
                fontFamily: 'bebas',
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            // Animations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // Temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'bebas',
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            // Weather Condition

            Text(
              _weather?.mainCondition ?? "",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'bebas',
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: searchWeather,
          elevation: 0,
          child: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.inversePrimary,
          )),
    );
  }
}
