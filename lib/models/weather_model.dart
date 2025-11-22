import 'package:intl/intl.dart';

/// Creating a class for weather model
class Weather {

  /// properties or variables to store weather data
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String conditionDescription;
  final double feelsLikeTemp;
  final double highestTemp;
  final double lowestTemp;
  final double windSpeed;
  final int humidity;
  final List<List<dynamic>> hourlyData;
  final List<List<dynamic>> dailyData;

  /// Constructor to initialize the variables
  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.conditionDescription,
    required this.feelsLikeTemp,
    required this.highestTemp,
    required this.lowestTemp,
    required this.windSpeed,
    required this.humidity,
    required this.hourlyData,
    required this.dailyData,
  });


}

// top-level parser (for compute)
Weather parseWeatherData(Map<String, dynamic> json) {
  final hourly = (json['hourly'] as List<dynamic>?) ?? [];
  final hourlyList = <List<String>>[];

  for (final item in hourly) {
    final dtTxt = (item['dt_txt'] ?? '').toString();
    final hourStr = dtTxt.length >= 13 ? dtTxt.substring(11, 13) : '00';
    final hourInt = int.tryParse(hourStr) ?? 0;
    final formatted = hourInt == 0 ? '12 AM' : (hourInt > 12 ? '${hourInt - 12} PM' : '$hourInt AM');
    final cond = item['weather'][0]['main'].toString();
    final temp = (item['main']['temp']).toString().split('.')[0];
    hourlyList.add([formatted, cond, temp]);
  }

  final daily = (json['daily'] as List<dynamic>?) ?? [];
  final dailyList = <List<String>>[];

  for (final item in daily) {

    final dt = (item['dt'] ?? 0).toInt();
    final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000).toLocal();
    final formatted = DateFormat('EEEE, d MMM').format(date);
    final maxTemp = (item['temp']['max']).toString().split('.')[0];
    final minTemp = (item['temp']['min']).toString().split('.')[0];

    final temp = '$maxTemp°/$minTemp°';
    final cond = item['weather'][0]['main'].toString();
    dailyList.add([formatted, temp, cond]);

  }

  return Weather(
    cityName: (json['location'] ?? 'Unknown').toString(),
    temperature: (json['current']?['main']?['temp'] ?? 0).toDouble(),
    mainCondition: (json['current']?['weather']?[0]?['main'] ?? '').toString(),
    conditionDescription: (json['current']?['weather']?[0]?['description'] ?? '').toString(),
    feelsLikeTemp: (json['current']?['main']?['feels_like'] ?? 0).toDouble(),
    highestTemp: (json['current']?['main']?['temp_max'] ?? 0).toDouble(),
    lowestTemp: (json['current']?['main']?['temp_min'] ?? 0).toDouble(),
    windSpeed: (json['current']?['wind']?['speed'] ?? 0).toDouble(),
    humidity: (json['current']?['main']?['humidity'] ?? 0).toInt(),
    hourlyData: hourlyList,
    dailyData: dailyList,
  );
}