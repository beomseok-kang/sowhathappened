import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(30)),
              SpinKitFadingCircle(
                color: Colors.grey,
                size: 100.0,
              ),

              Padding(padding: EdgeInsets.all(12),),

              Text('로딩 중...', style: TextStyle(fontSize: 20),),
              Padding(padding: EdgeInsets.all(30),)
            ],
          ),
        )
    );
  }
}
