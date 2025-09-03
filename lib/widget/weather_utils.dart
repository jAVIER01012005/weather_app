// widgets/weather_widgets.dart
import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../utils/weather_utils.dart';

class WeatherWidgets {
  
  static Widget buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Obteniendo datos meteorológicos...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  static Widget buildErrorWidget(String errorMessage, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            SizedBox(height: 16),
            Text(
              'Error al cargar datos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Intentar nuevamente'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wb_sunny,
            size: 64,
            color: Colors.white70,
          ),
          SizedBox(height: 16),
          Text(
            'Busca una ciudad para ver el pronóstico',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  static Widget buildCurrentWeatherCard(WeatherData currentWeather) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              currentWeather.cityName,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Actualizado: ${WeatherUtils.formatTime(currentWeather.lastUpdate)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(
                      WeatherUtils.getWeatherIcon(currentWeather.condition),
                      size: 80,
                      color: WeatherUtils.getTemperatureColor(currentWeather.temperature),
                    ),
                    SizedBox(height: 8),
                    Text(
                      currentWeather.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${currentWeather.temperature.round()}°',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: WeatherUtils.getTemperatureColor(currentWeather.temperature),
                      ),
                    ),
                    Text(
                      'Celsius',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildWeatherDetailsCard(WeatherData currentWeather) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  Icons.air,
                  'Viento',
                  '${currentWeather.windSpeed.toStringAsFixed(1)} km/h',
                ),
                _buildDetailItem(
                  Icons.water_drop,
                  'Humedad',
                  '${currentWeather.humidity}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue[600]),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  static Widget buildForecastCard(List<WeatherForecast> forecast) {
    if (forecast.isEmpty) return SizedBox.shrink();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pronóstico Extendido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: forecast.length,
                itemBuilder: (context, index) {
                  final forecastItem = forecast[index];
                  return Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Text(
                          WeatherUtils.formatDay(forecastItem.date),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
                        Icon(
                          WeatherUtils.getWeatherIcon(forecastItem.condition),
                          size: 32,
                          color: Colors.blue[600],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${forecastItem.maxTemp.round()}°',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${forecastItem.minTemp.round()}°',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildCitySearchField(TextEditingController controller, VoidCallback onSearch) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Ingresa el nombre de la ciudad',
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: onSearch,
              ),
            ),
            onSubmitted: (_) => onSearch(),
          ),
        ),
      ),
    );
  }
}