import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:clima_weather/utilities/constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SpinKitFadingCircle(
              color: kLightColor,
              size: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Fetching data...',
              style: TextStyle(
                fontSize: 20,
                color: kMidLightColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
