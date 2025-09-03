// screens/weather_home_page.dart
import 'package:flutter/material.dart';
import 'package:weather_app/widget/weather_utils.dart';
import 'dart:async';
import '../models/weather_data.dart';
import '../services/weather_service.dart';

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();
  
  WeatherData? _currentWeather;
  List<WeatherForecast> _forecast = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _updateTimer;
  
  // Configuración para actualización automática (cada 10 minutos)
  static const Duration _updateInterval = Duration(minutes: 10);

  @override
  void initState() {
    super.initState();
    _cityController.text = 'La Ceiba'; // Ciudad por defecto
    _loadWeatherData();
    _startAutoUpdate();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _weatherService.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // Iniciar actualización automática
  void _startAutoUpdate() {
    _updateTimer = Timer.periodic(_updateInterval, (timer) {
      if (_cityController.text.isNotEmpty) {
        _loadWeatherData();
      }
    });
  }

  // Cargar datos meteorológicos
  Future<void> _loadWeatherData() async {
    if (_cityController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Cargar datos actuales y pronóstico en paralelo
      final results = await Future.wait([
        _weatherService.getCurrentWeather(_cityController.text),
        _weatherService.getForecast(_cityController.text),
      ]);

      setState(() {
        _currentWeather = results[0] as WeatherData?;
        _forecast = results[1] as List<WeatherForecast>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Actualización manual
  Future<void> _refreshWeather() async {
    await _loadWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pronóstico del Tiempo'),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshWeather,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[600]!, Colors.blue[100]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Campo de búsqueda de ciudad
              WeatherWidgets.buildCitySearchField(_cityController, _loadWeatherData),

              // Contenido principal
              Expanded(
                child: _isLoading
                    ? WeatherWidgets.buildLoadingWidget()
                    : _errorMessage != null
                        ? WeatherWidgets.buildErrorWidget(_errorMessage!, _loadWeatherData)
                        : _currentWeather != null
                            ? _buildWeatherContent()
                            : WeatherWidgets.buildEmptyState(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    return RefreshIndicator(
      onRefresh: _refreshWeather,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Información meteorológica actual
            WeatherWidgets.buildCurrentWeatherCard(_currentWeather!),
            SizedBox(height: 16),
            
            // Información adicional
            WeatherWidgets.buildWeatherDetailsCard(_currentWeather!),
            SizedBox(height: 16),
            
            // Pronóstico extendido
            WeatherWidgets.buildForecastCard(_forecast),
          ],
        ),
      ),
    );
  }
}