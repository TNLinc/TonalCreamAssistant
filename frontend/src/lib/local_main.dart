import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'pages/home/home_page.dart';

Future<void> main() async {
  if (!kIsWeb) {
    await WidgetsFlutterBinding.ensureInitialized();
    //Initialize Logging
    FlutterLogs.initLogs(
        logLevelsEnabled: [
          LogLevel.INFO,
          LogLevel.WARNING,
          LogLevel.ERROR,
          LogLevel.SEVERE
        ],
        timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
        directoryStructure: DirectoryStructure.FOR_DATE,
        logTypesEnabled: ["device", "network", "errors"],
        logFileExtension: LogFileExtension.LOG,
        logsWriteDirectoryName: "MyLogs",
        logsExportDirectoryName: "MyLogs/Exported",
        debugFileOperations: true,
        isDebuggable: true);
  }
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://90cf2a7c5f5c4970ad321848bd2e76ad@o1083764.ingest.sentry.io/6093544';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}

const String cvHost = 'http://127.0.0.1';
const String vendorHost = 'http://127.0.0.1';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return MaterialApp(
          title: 'Tonal cream assistant',
          key: Key('MaterialAppWidget'),
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
                      fontSize: 66.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'inter',
                      color: Colors.amber),
                  // Steps
                  headline5: TextStyle(
                    fontSize: 20.5.sp,
                    fontFamily: 'inter',
                    color: Colors.white,
                  ),
                  bodyText1: const TextStyle(
                    fontFamily: 'inter',
                    color: Colors.white,
                  ))),
          home: Builder(
            builder: (context) => ResponsiveWrapper.builder(
              const HomePage(cvHost: cvHost, vendorHost: vendorHost),
              maxWidth: 1200,
              minWidth: 320,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(320, name: MOBILE),
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
