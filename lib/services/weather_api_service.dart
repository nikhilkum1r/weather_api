import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherApiService extends ChangeNotifier {
  final String apiKey =
      'YOUR_API_KEY'; // Replace with your API key
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  Map<String, dynamic>? _weatherData;
  String? _errorMessage;

  Map<String, dynamic>? get weatherData => _weatherData;
  String? get errorMessage => _errorMessage;

  Future<void> getWeatherData(String cityName) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));
      if (response.statusCode == 200) {
        _weatherData = jsonDecode(response.body);
        _errorMessage = null;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('lastCity', cityName);
      } else {
        _errorMessage =
            'Failed to load weather data. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Failed to load weather data: $e';
    }
    notifyListeners();
  }

  Future<void> fetchLastCityWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastCity = prefs.getString('lastCity');
    if (lastCity != null) {
      await getWeatherData(lastCity);
    }
  }
}
