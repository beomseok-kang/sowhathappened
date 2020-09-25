import 'package:flutter/material.dart';
import 'package:sowhathappened/style/style_standard.dart';

class StandardButton extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final Color buttonColor;
  final Color textColor;

  StandardButton({
    @required this.onTap,
    @required this.title,
    @required this.buttonColor,
    @required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: buttonColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0,13),
                blurRadius: 13,
                color: shadowColor()
              )
            ]
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize:20, color: textColor, fontWeight: FontWeight.bold),)),
        ),
      ),
    );
  }
}