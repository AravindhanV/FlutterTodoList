import 'package:flutter/material.dart';
import 'package:flutterworkshop/home.dart';
import 'package:flutterworkshop/test.dart';

void main() => runApp(MyApp());

ThemeData buildTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // '/': (context) => FirstPage(),
        '/': (context) => HomePage(),
      },
    );
  }
}