import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sowhathappened/home_page.dart';
import 'package:sowhathappened/models/user.dart';
import 'package:sowhathappened/services/auth.dart';
import 'package:sowhathappened/services/queries.dart';
import 'package:sowhathappened/style/style_standard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        ChangeNotifierProvider<Queries>(create: (_) => Queries(),)
      ],
      child: MaterialApp(
        title: '그래서 어떻게 됐는데',
        theme: ThemeData(
          fontFamily: "NotoSans",
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: textColor()
            ),
            bodyText2: TextStyle(
                color: textColor()
            ),
          ),
          primarySwatch: Colors.grey,
        ),
        home: SafeArea(
            child: HomePage()),
      ),
    );
  }
}
