// utils/weather_utils.dart
import 'package:flutter/material.dart';

class WeatherUtils {
  // Obtener icono según condición meteorológica
  static IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.wb_cloudy;
      case 'rain':
        return Icons.umbrella;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  // Obtener color según temperatura
  static Color getTemperatureColor(double temperature) {
    if (temperature > 30) return Colors.red;
    if (temperature > 20) return Colors.orange;
    if (temperature > 10) return Colors.green;
    if (temperature > 0) return Colors.blue;
    return Colors.indigo;
  }

  // Formatear tiempo
  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Formatear día de la semana
  static String formatDay(DateTime dateTime) {
    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return days[dateTime.weekday - 1];
  }
}