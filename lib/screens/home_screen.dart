import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/weather_details_screen.dart';
import 'package:weather_app/services/weather_api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLastSearchedCity();
  }

  void _loadLastSearchedCity() async {
    await Provider.of<WeatherApiService>(context, listen: false)
        .fetchLastCityWeather();
    final lastCity = Provider.of<WeatherApiService>(context, listen: false)
        .weatherData?['name'];
    if (lastCity != null) {
      _cityController.text = lastCity;
    }
  }

  void _searchWeather(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<WeatherApiService>(context, listen: false)
        .getWeatherData(_cityController.text);
    setState(() {
      _isLoading = false;
    });
    if (Provider.of<WeatherApiService>(context, listen: false).weatherData !=
        null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailsScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Provider.of<WeatherApiService>(context, listen: false)
                    .errorMessage ??
                'Unknown error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _searchWeather(context),
                    child: Text('Get Weather'),
                  ),
          ],
        ),
      ),
    );
  }
}
