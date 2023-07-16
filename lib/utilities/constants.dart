import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const apiKey = 'cb1d50cb4d3a7611378de745dfd47b34';

const kLightColor = Colors.white;
const kMidLightColor = Colors.white60;
const kOverlayColor = Colors.white10;
const kDarkColor = Colors.white24;

const kTextFieldTextStyle = TextStyle(
  fontSize: 16,
  color: kMidLightColor,
);

var kLocationTextStyle = GoogleFonts.monda(
  fontSize: 20,
  color: kMidLightColor,
);

var kTempTextStyle = GoogleFonts.daysOne(
  fontSize: 80,
);

var kDetailsTextStyle = GoogleFonts.monda(
  fontSize: 20,
  color: kMidLightColor,
  fontWeight: FontWeight.bold,
);

var kDetailsTitleTextStyle = GoogleFonts.monda(
  fontSize: 16,
  color: kDarkColor,
);

var kDetailsSuffixTextStyle = GoogleFonts.monda(
  fontSize: 12,
  color: kMidLightColor,
);

const kTitle = TextStyle(
  fontSize: 16,
  color: kMidLightColor,
  fontWeight: FontWeight.bold,
);

const kTextFieldDecoration = InputDecoration(
  fillColor: kOverlayColor,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide.none,
  ),
  hintText: "Enter city name",
  hintStyle: kTextFieldTextStyle,
  prefixIcon: Icon(Icons.search),
);
