import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/weather_api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherData = Provider.of<WeatherApiService>(context).weatherData;
    if (weatherData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Weather Details'),
        ),
        body: Center(
          child: Text('No weather data available.'),
        ),
      );
    }

    final String cityName = weatherData['name'];
    final double temperature = weatherData['main']['temp'];
    final String weatherCondition = weatherData['weather'][0]['description'];
    final String iconCode = weatherData['weather'][0]['icon'];
    final int humidity = weatherData['main']['humidity'];
    final double windSpeed = weatherData['wind']['speed'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cityName,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              CachedNetworkImage(
                imageUrl: 'http://openweathermap.org/img/wn/$iconCode@2x.png',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text(
                '$temperature °C',
                style: TextStyle(fontSize: 32),
              ),
              Text(
                weatherCondition,
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Humidity: $humidity%',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Wind Speed: $windSpeed m/s',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Provider.of<WeatherApiService>(context, listen: false).getWeatherData(cityName);
                },
                child: Text('Refresh'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
