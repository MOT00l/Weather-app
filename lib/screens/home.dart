import 'package:clima_weather/components/error_message.dart';
import 'package:clima_weather/models/weather_models.dart';
import 'package:clima_weather/services/weather.dart';
import 'package:clima_weather/utilities/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

import '../components/details_widget.dart';
import 'package:clima_weather/components/loading_widget.dart';
import 'package:clima_weather/utilities/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;
  bool isErrorOccurd = false;
  double? latitude;
  double? longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
  WeatherModel? weatherModel;
  int code = 0;
  Weather weather = Weather();
  var weatherData;
  String? title, message;

  @override
  void initState() {
    super.initState();
    getPremission();
  }

  void getPremission() async {
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
        } else {
          getLocation();
        }
      } else {}
    } else {
      getLocation();
    }
  }

  void getLocation() async {
    if (!await geolocatorPlatform.isLocationServiceEnabled()) {
      setState(() {
        isErrorOccurd = true;
        isDataLoaded = true;
        title = "Location is turned off";
        message =
            "Please enable the location service to see weather condition for your location";
        return;
      });
    }
    weatherData = await weather.getLocationWeather();
    code = weatherData["weather"][0]["id"];
    weatherModel = WeatherModel(
      temperatur: weatherData["main"]["temp"],
      feelslike: weatherData["main"]["feels_like"],
      humidity: weatherData["main"]["humidity"],
      wind: weatherData["wind"]["speed"],
      icon:
          "assets/weather-icons/${getIconsPreFix(code)}${kWeatherIcons[code.toString()]!["icon"]}.svg",
      location: weatherData["name"] + ", " + weatherData["sys"]["country"],
      description: weatherData["weather"][0]["description"],
    );
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const LoadingWidget();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kOverlayColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white12,
                        child: const SizedBox(
                          height: 60,
                          child: Center(
                            child: Text(
                              "CLIMA WEATHER",
                              style: kTitle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          getPremission();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Text("My Location", style: kTextFieldTextStyle),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.gps_fixed,
                                color: Colors.white60,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isErrorOccurd
                  ? ErrorMessage(title: title!, message: message!)
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_city,
                                color: kMidLightColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                weatherModel?.location! ?? "no data",
                                style: kLocationTextStyle,
                              )
                            ],
                          ),
                          const SizedBox(height: 25),
                          SvgPicture.asset(
                            weatherModel!.icon!,
                            height: 280,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            "${weatherModel?.temperatur!.round()}°",
                            style: kTempTextStyle,
                          ),
                          Text(
                            weatherModel?.description!.toUpperCase() ??
                                "no data",
                            style: kLocationTextStyle,
                          ),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: kOverlayColor,
                  child: SizedBox(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DetailsWidget(
                          text: "${weatherModel?.feelslike!.round()}°",
                          detailText: "FEELS LIKE",
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        DetailsWidget(
                          text: "${weatherModel?.humidity!}%",
                          detailText: "HUMIDITY",
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                          ),
                        ),
                        DetailsWidget(
                          text: "${weatherModel?.wind!.round()}",
                          detailText: "WIND",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
