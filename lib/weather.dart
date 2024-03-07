import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherData {
  final String city;
  final double temperature;
  final String conditions;
  final double windSpeed;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.conditions,
    required this.windSpeed,
  });
}

class WeatherForecastApp extends StatefulWidget {
  @override
  _WeatherForecastAppState createState() => _WeatherForecastAppState();
}

class _WeatherForecastAppState extends State<WeatherForecastApp> {
  WeatherData? _weatherData;

  Future<void> _fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_API_KEY'));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      setState(() {
        _weatherData = WeatherData(
          city: weatherData['name'],
          temperature: (weatherData['main']['temp'] - 273.15),
          conditions: weatherData['weather'][0]['main'],
          windSpeed: weatherData['wind']['speed'],
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: Center(
        child: _weatherData == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weatherData!.city,
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    '${_weatherData!.temperature.toStringAsFixed(1)} °C',
                    style: TextStyle(fontSize: 32),
                  ),
                  Text(
                    _weatherData!.conditions,
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Wind Speed: ${_weatherData!.windSpeed.toString()} m/s',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
      ),
    );
  }
}
