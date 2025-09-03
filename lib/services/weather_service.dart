// services/weather_service.dart - Versión simplificada sin IOClient
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  static const String baseUrl = 'https://api.weatherapi.com/v1';
  static const String apiKey = '700e0fd6d0e84bf584160541253108';
  
  final http.Client _client = http.Client();

  // Método principal para obtener clima actual
  Future<WeatherData?> getCurrentWeather(String cityName) async {
    print('🌍 Buscando clima para: $cityName');
    
    try {
      await _checkConnectivity();
      
      // Intento 1: HTTPS
      try {
        return await _getCurrentWeatherHTTPS(cityName);
      } catch (httpsError) {
        print('⚠️ HTTPS falló: $httpsError');
        
        // Intento 2: HTTP como respaldo
        try {
          return await _getCurrentWeatherHTTP(cityName);
        } catch (httpError) {
          print('⚠️ HTTP también falló: $httpError');
          
          // Re-lanzar el error más específico
          throw httpsError;
        }
      }
    } catch (e) {
      print('💥 Error final: $e');
      _handleError(e);
      return null;
    }
  }

  // Método HTTPS
  Future<WeatherData?> _getCurrentWeatherHTTPS(String cityName) async {
    final url = '$baseUrl/current.json?key=$apiKey&q=${Uri.encodeComponent(cityName)}&aqi=no&lang=es';
    print('🔗 URL HTTPS: $url');
    
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'WeatherApp/1.0',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: 20));

    print('📡 Respuesta HTTPS: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Datos HTTPS obtenidos correctamente');
      return _parseWeatherAPIData(data);
    } else {
      throw Exception('HTTPS Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Método HTTP alternativo
  Future<WeatherData?> _getCurrentWeatherHTTP(String cityName) async {
    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=${Uri.encodeComponent(cityName)}&aqi=no&lang=es';
    print('🔗 URL HTTP: $url');
    
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'WeatherApp/1.0',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: 25));

    print('📡 Respuesta HTTP: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Datos HTTP obtenidos correctamente');
      return _parseWeatherAPIData(data);
    } else {
      throw Exception('HTTP Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Parsear datos de WeatherAPI
  WeatherData _parseWeatherAPIData(Map<String, dynamic> data) {
    final location = data['location'];
    final current = data['current'];
    final condition = current['condition'];

    String mappedCondition = _mapWeatherAPICondition(condition['text']);

    return WeatherData(
      temperature: current['temp_c'].toDouble(),
      condition: mappedCondition,
      description: condition['text'],
      windSpeed: current['wind_kph'].toDouble(),
      humidity: current['humidity'],
      cityName: location['name'],
      lastUpdate: DateTime.now(),
      forecast: [],
    );
  }

  // Mapear condiciones
  String _mapWeatherAPICondition(String condition) {
    final lowerCondition = condition.toLowerCase();
    
    if (lowerCondition.contains('sunny') || lowerCondition.contains('clear')) {
      return 'clear';
    } else if (lowerCondition.contains('cloud') || lowerCondition.contains('overcast')) {
      return 'clouds';
    } else if (lowerCondition.contains('rain') || lowerCondition.contains('drizzle')) {
      return 'rain';
    } else if (lowerCondition.contains('snow')) {
      return 'snow';
    } else if (lowerCondition.contains('thunder') || lowerCondition.contains('storm')) {
      return 'thunderstorm';
    } else {
      return 'clouds';
    }
  }

  // Obtener pronóstico
  Future<List<WeatherForecast>> getForecast(String cityName) async {
    print('📅 Obteniendo pronóstico para: $cityName');
    
    try {
      await _checkConnectivity();
      
      // Intentar HTTPS primero
      try {
        return await _getForecastHTTPS(cityName);
      } catch (e) {
        print('⚠️ Pronóstico HTTPS falló, intentando HTTP: $e');
        return await _getForecastHTTP(cityName);
      }
    } catch (e) {
      print('💥 Error en pronóstico: $e');
      return []; // Retornar lista vacía en caso de error
    }
  }

  // Pronóstico HTTPS
  Future<List<WeatherForecast>> _getForecastHTTPS(String cityName) async {
    final url = '$baseUrl/forecast.json?key=$apiKey&q=${Uri.encodeComponent(cityName)}&days=5&aqi=no&alerts=no&lang=es';
    
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'WeatherApp/1.0',
      },
    ).timeout(Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final forecastDays = data['forecast']['forecastday'] as List;
      
      return forecastDays.map<WeatherForecast>((day) {
        final dayData = day['day'];
        return WeatherForecast(
          date: DateTime.parse(day['date']),
          maxTemp: dayData['maxtemp_c'].toDouble(),
          minTemp: dayData['mintemp_c'].toDouble(),
          condition: _mapWeatherAPICondition(dayData['condition']['text']),
        );
      }).toList();
    } else {
      throw Exception('Forecast HTTPS error: ${response.statusCode}');
    }
  }

  // Pronóstico HTTP
  Future<List<WeatherForecast>> _getForecastHTTP(String cityName) async {
    final url = 'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=${Uri.encodeComponent(cityName)}&days=5&aqi=no&alerts=no';
    
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'WeatherApp/1.0',
      },
    ).timeout(Duration(seconds: 25));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final forecastDays = data['forecast']['forecastday'] as List;
      
      return forecastDays.map<WeatherForecast>((day) {
        final dayData = day['day'];
        return WeatherForecast(
          date: DateTime.parse(day['date']),
          maxTemp: dayData['maxtemp_c'].toDouble(),
          minTemp: dayData['mintemp_c'].toDouble(),
          condition: _mapWeatherAPICondition(dayData['condition']['text']),
        );
      }).toList();
    } else {
      throw Exception('Forecast HTTP error: ${response.statusCode}');
    }
  }

  // Verificar conectividad
  Future<void> _checkConnectivity() async {
    try {
      print('🔍 Verificando conectividad...');
      final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 8));
      if (result.isEmpty) {
        throw SocketException('Sin conectividad a internet');
      }
      print('✅ Conectividad confirmada');
    } catch (e) {
      print('❌ Sin conectividad: $e');
      throw SocketException('🌐 Sin conexión a internet. Verifica tu red.');
    }
  }

  // Manejo de errores
  void _handleError(dynamic error) {
    if (error is SocketException) {
      if (error.toString().contains('Operation not permitted') || 
          error.toString().contains('errno = 1')) {
        throw Exception('🔒 Problema de permisos de red. Verifica la configuración de tu dispositivo o intenta con WiFi diferente.');
      } else if (error.toString().contains('Connection failed') ||
                 error.toString().contains('Connection timed out')) {
        throw Exception('🌐 Sin conexión a internet. Verifica tu WiFi o datos móviles.');
      } else {
        throw Exception('🔌 Error de conexión de red: ${error.message ?? error.toString()}');
      }
    } else if (error is TimeoutException) {
      throw Exception('⏱️ Tiempo de espera agotado. Tu conexión es muy lenta, intenta de nuevo.');
    } else if (error is FormatException) {
      throw Exception('📋 Respuesta inválida del servidor. Intenta más tarde.');
    } else if (error is http.ClientException) {
      throw Exception('🔌 Error de cliente HTTP: ${error.message}');
    } else if (error.toString().contains('400')) {
      throw Exception('🏙️ Ciudad no encontrada. Verifica la ortografía del nombre.');
    } else if (error.toString().contains('401')) {
      throw Exception('🔑 API Key inválida. Contacta al desarrollador.');
    } else if (error.toString().contains('403')) {
      throw Exception('🚫 Acceso denegado. Límite de API excedido.');
    } else if (error.toString().contains('429')) {
      throw Exception('⏰ Demasiadas solicitudes. Espera un momento e intenta de nuevo.');
    } else {
      throw Exception('💥 Error inesperado: ${error.toString()}');
    }
  }

  // Método de prueba simple
  Future<bool> testConnection() async {
    try {
      print('🧪 Probando conexión con WeatherAPI...');
      
      final response = await _client.get(
        Uri.parse('$baseUrl/current.json?key=$apiKey&q=London&aqi=no'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 15));

      print('📡 Test resultado: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('✅ Conexión exitosa');
        return true;
      } else {
        print('❌ Conexión falló: ${response.statusCode}');
        print('📄 Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('💥 Test falló: $e');
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}