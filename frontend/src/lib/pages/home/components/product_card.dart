import 'package:TonalCreamAssistant/utils/hex_color.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

_launchURL(url) async {
  try {
    await launch(url);
  } catch (exception, stackTrace) {
    FlutterLogs.logInfo("Error", "Error opening page by url",
        "url: $url");
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String color;
  final String url;

  const ProductCard({Key? key, required this.name, required this.color, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _launchURL(url),
        child: Card(
      elevation: 4,
      color: HexColor(color),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: BorderedText(
              strokeWidth: 2,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
