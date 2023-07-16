import 'package:clima_weather/services/location.dart';
import 'package:clima_weather/services/networking.dart';

import '../utilities/constants.dart';

class Weather {
  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
      "https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric",
    );
    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  // Future<dynamic> getCityWeather(String cityName) async {
  //   NetworkHelper networkHelper = NetworkHelper(
  //     "https://api.openweathermap.org/data/2.5/weather?id=$cityName&appid=$apiKey"
  //   );

  //   var weatherData = await networkHelper.getData();
  //   return weatherData;
  // }
}
