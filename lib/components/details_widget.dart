import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class DetailsWidget extends StatelessWidget {
  final String? text;
  final String? detailText;
  const DetailsWidget(
      {super.key, required this.detailText, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(text!, style: kDetailsTextStyle),
            Visibility(
              visible: detailText == "WIND" ? true : false,
              child: Text(
                " km/hr",
                style: kDetailsSuffixTextStyle,
              ),
            )
          ],
        ),
        Text(
          detailText!,
          style: kDetailsTitleTextStyle,
        )
      ],
    );
  }
}
