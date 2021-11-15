import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

const String host = 'tnl-cv-eu.herokuapp.com';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
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
              textTheme: TextTheme(
                // Header
                headline1: TextStyle(
                    fontSize: kIsWeb ? 66.sp : 72.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'inter',
                    color: Colors.amber),
                // Steps
                headline5: TextStyle(
                  fontSize: kIsWeb ? 20.5.sp : 25.sp,
                  fontFamily: 'inter',
                  color: Colors.white,
                ),
              )),
          home: Builder(
            builder: (context) => ResponsiveWrapper.builder(
              const HomePage(host: host),
              maxWidth: 1200,
              minWidth: 480,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(480, name: MOBILE),
                const ResponsiveBreakpoint.resize(800, name: TABLET),
                const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ],
              background: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
          ));
    });
  }
}
