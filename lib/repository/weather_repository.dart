import 'package:design/model/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherRepository {
  final String apiKey =
      '12b6d9fa6920fb65620695e91d82639c'; // Your actual API key

  //? Method to fetch city ID based on city name
  Future<int> fetchCityId(String cityName) async {
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Failed to fetch city ID: ${response.body}');
    }
  }

  //?s Method to fetch weather data using city ID
  Future<Weather> fetchWeather(int cityId) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?id=$cityId&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather: ${response.body}');
    }
  }
}
