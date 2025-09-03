// constants/app_constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration
static const String API_BASE_URL = 'https://api.weatherapi.com/v1';
  static const String API_KEY = '700e0fd6d0e84bf584160541253108'; // Reemplazar con tu API key
  
  // Timing Configuration
  static const Duration API_TIMEOUT = Duration(seconds: 10);
  static const Duration AUTO_UPDATE_INTERVAL = Duration(minutes: 10);
  
  // Default Values
  static const String DEFAULT_CITY = 'La Ceiba';
  
  // Colors
  static const Color PRIMARY_COLOR = Colors.blue;
  static const Color BACKGROUND_START = Color(0xFF1976D2);
  static const Color BACKGROUND_END = Color(0xFFBBDEFB);
  
  // Text Styles
  static const TextStyle TITLE_STYLE = TextStyle(
    fontSize: 28, 
    fontWeight: FontWeight.bold
  );
  
  static const TextStyle SUBTITLE_STYLE = TextStyle(
    fontSize: 16, 
    fontWeight: FontWeight.w500
  );
  
  static const TextStyle TEMPERATURE_STYLE = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.bold,
  );
  
  // Dimensions
  static const double CARD_BORDER_RADIUS = 16.0;
  static const double CARD_ELEVATION = 8.0;
  static const double STANDARD_PADDING = 16.0;
  static const double LARGE_PADDING = 24.0;
  
  // Weather Icons Map
  static const Map<String, IconData> WEATHER_ICONS = {
    'clear': Icons.wb_sunny,
    'clouds': Icons.wb_cloudy,
    'rain': Icons.umbrella,
    'snow': Icons.ac_unit,
    'thunderstorm': Icons.flash_on,
  };
  
  // Temperature Color Thresholds
  static const double TEMP_HOT_THRESHOLD = 30.0;
  static const double TEMP_WARM_THRESHOLD = 20.0;
  static const double TEMP_COOL_THRESHOLD = 10.0;
  static const double TEMP_COLD_THRESHOLD = 0.0;
  
  // Messages
  static const String LOADING_MESSAGE = 'Obteniendo datos meteorológicos...';
  static const String ERROR_TITLE = 'Error al cargar datos';
  static const String RETRY_BUTTON_TEXT = 'Intentar nuevamente';
  static const String EMPTY_STATE_MESSAGE = 'Busca una ciudad para ver el pronóstico';
  static const String SEARCH_HINT = 'Ingresa el nombre de la ciudad';
  static const String REFRESH_TOOLTIP = 'Actualizar';
  
  // Days of the week in Spanish
  static const List<String> WEEKDAYS = [
    'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'
  ];
}