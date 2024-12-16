class Weather {

  final int? pressure;
  final  double minTemp;
  final double? maxtemp;
  final String cityName;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final String description;

  Weather({
    required this.pressure,
    required this.minTemp,
    required this.maxtemp,
    required this.cityName,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      maxtemp: json['main']['temp_max'].toDouble(),
      minTemp: json['main']['temp_min'].toDouble(),
      cityName: json['name'],
      pressure: json['main']['pressure'],
      temperature: json['main']['temp'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      description: json['weather'][0]['description'],
    );}}