import 'dart:convert'; // to use jsonDecode
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart'; // to get the coordinates of the current location
import '../models/weather_model.dart'; // Importing our Weather model
import 'package:http/http.dart' as http; // importing our HTTP package to send requests

/// A class to fetch the data
class WeatherService {

  /// API key
  // This declares a variable that will store our API key which comes from weather page.
  final String apiKey;



  // Constructor of the class that takes the apiKey
  WeatherService({required this.apiKey});

  /// Function to get API response
  // It is an function that takes a cityName (like "Dhaka"),works asynchronously
  // (so we can wait for internet results), And returns a Weather object in the future
  // (using Future<Weather>). This object goes to the weather model
  Future<Weather> getWeather(String coordinates) async {

    /// Split the coordinates into latitude and longitude
    // to store them differently. Using .split()
    // Its separating them at the space character.
    final String lat = coordinates.split(" ")[0];
    final String lon = coordinates.split(" ")[1];

    final currentUrl = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey',
    );

    final hourlyUrl = Uri.parse(
      'https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=$lat&lon=$lon&units=metric&appid=$apiKey&cnt=24',
    );

    final dailyUrl = Uri.parse(
      'https://pro.openweathermap.org/data/2.5/forecast/daily?lat=$lat&lon=$lon&cnt=7&units=metric&appid=$apiKey',
    );

    try {
      // Fetch all in parallel
      final response = await Future.wait([
        http.get(currentUrl),
        http.get(hourlyUrl),
        http.get(dailyUrl),
      ]);


      // Checks if the server’s response code is 200, which means success.
      if (response[2].statusCode == 200) {
        // response[0].body is the raw JSON string from the API.
        // Using jsonDecode() we can convert JSON text (a string from the API) into a Map
        // that Dart can understand .
        final currentData = json.decode(response[0].body);
        final hourlyData = json.decode(response[1].body);
        final dailyData = json.decode(response[2].body);

        // Merge into one structured object
        final mergedData = {
          "location": currentData["name"],
          "coordinates": {
            "lat": lat,
            "lon": lon,
          },
          "current": currentData,
          "hourly": hourlyData['list'] ?? [],
          "daily": dailyData['list'] ?? [],
        };

        // response.body is the raw JSON string from the API.
        // Using jsonDecode() we can convert JSON text (a string from the API) into a Map
        // that Dart can understand .
        // Weather.fromJson() converts that map into a Weather object (using our factory constructor from the Weather model).
        // That Weather object is returned to whoever called getWeather()

        // return Weather.fromJson(mergedData);
        // ✅ Offload heavy parsing to a background isolate
        final Weather weather = await compute(parseWeatherData, mergedData);
        return weather;
      } else {
        // If the status code is not 200, it means something went wrong (maybe city not found or wrong API key).
        // So it throws an Exception to stop the program and show an error message.
        throw Exception(
            'Failed to load weather data. Server Status Code - ${response[2]
                .statusCode}'
        );
      }
    } on http.ClientException {
      throw Exception('No Internet connection, Connection failed');
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }

  }

  /// Function to get the location of the device
  // It's an asynchronous function called getCurrentCity. It returns a Future<String>,
  // meaning it will give us the city name later (after some waiting). async allows using
  // await inside (for operations that take time, like GPS fetching).
  Future<String> getCurrentCity () async{

    /// get permission to access location
    // Geolocator.checkPermission() this checks what kind of location permission our app currently has.
    // It could be:
    // LocationPermission.denied (not allowed yet)
    // LocationPermission.whileInUse (allowed)
    // LocationPermission.always, etc.
    // We must have permission before accessing GPS
    LocationPermission permission = await Geolocator.checkPermission();

    // If the user hasn’t granted permission yet, this asks the user again using a popup
    // “Allow this app to access your location?” using requestPermission() method. If the
    // user agrees, permission gets updated.
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    /// fetch current location
    // This actually gets the GPS coordinates (latitude and longitude) of the user’s current position.
    // await waits until the GPS finds the location. locationSettings: const LocationSettings( accuracy: LocationAccuracy.high) → get as
    // accurate data as possible (slower, but more precise).
    Position position = await Geolocator.getCurrentPosition(

      locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high
      ),

    );

    /// return the latitude and longitude as a single string
    // separated by a space
    return "${position.latitude} ${position.longitude}";

  }

  /// Function for getting the city name from the coordinates
  Future<String> getCurrentCityName (String coordinates) async {

    final lat = double.parse(coordinates.split(" ")[0]);
    final lon = double.parse(coordinates.split(" ")[1]);
    // Getting the api key from the .env
    final apiKey = dotenv.env['LOCATION_IQ_KEY'] ?? '';

    final url = "https://us1.locationiq.com/v1/reverse?key=$apiKey&lat=$lat&lon=$lon&format=json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["address"]["suburb"] ?? "Unknown";
    } else {
      return "Unknown";
    }

  }

}