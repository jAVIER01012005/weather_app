// models/weather_data.dart
class WeatherData {
  final double temperature;
  final String condition;
  final String description;
  final double windSpeed;
  final int humidity;
  final String cityName;
  final DateTime lastUpdate;
  final List<WeatherForecast> forecast;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    required this.cityName,
    required this.lastUpdate,
    required this.forecast,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      cityName: json['name'],
      lastUpdate: DateTime.now(),
      forecast: [], // Se llenará con datos de pronóstico
    );
  }
}

class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;

  WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
  });
}