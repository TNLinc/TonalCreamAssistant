import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tonal cream assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.amber,
          primaryColorLight: Colors.amber[200],
          errorColor: Colors.redAccent,
          scaffoldBackgroundColor: Colors.tealAccent[700],
          disabledColor: Colors.grey[350],
          bottomAppBarColor: Colors.tealAccent,
          shadowColor: Colors.black45,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber),
          )),
          iconTheme: const IconThemeData(color: Colors.redAccent),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.amber,
          ),
          canvasColor: Colors.transparent,
          textTheme: const TextTheme(
            // Header
            headline1: TextStyle(
                fontSize: 72.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'inter',
                color: Colors.amber),
            // Steps
            headline5: TextStyle(fontFamily: 'inter', color: Colors.white),
          )),
      home: const HomePage(),
    );
  }
}
