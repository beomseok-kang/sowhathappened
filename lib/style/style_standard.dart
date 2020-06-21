import 'package:flutter/material.dart';

titleStyle() {
  return TextStyle(fontSize: 16);
}

headingStyle() {
  return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
}

selectionStyle(int currentIndex, int index) {
  return TextStyle(
      color: currentIndex == index ? colorOnSelection() : colorNotSelected(),
      fontWeight: currentIndex == index ? FontWeight.bold : null);
}

bigHeaderStyle() {
  return TextStyle(
      color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold);
}

String cutBracket(String string) {
  return string.substring(1, string.length - 1);
}

Color shadowColor() {
  return Color.fromRGBO(218, 216, 234, 0.16);
}

Color bgColor() {
  return Color.fromRGBO(252, 253, 255, 1);
}

Color appBarColor() {
  return Color.fromRGBO(245, 250, 253, 0.8);
}

Color textColor() {
  return Color.fromRGBO(85, 85, 100, 1);
}

Color colorOnSelection() {
  return Color.fromRGBO(0, 56, 234, 0.6);
}

Color colorNotSelected() {
  return Color.fromRGBO(160, 168, 178, 0.8);
}

Color colorForLike() {
  return Color.fromRGBO(250, 100, 100, 0.5);
}
