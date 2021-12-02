import 'package:flutter/material.dart';

bool checkWrap(BuildContext context) {
  Size headerTextSize =
      _textSize('Tonal assistant', Theme.of(context).textTheme.headline1!);
  return headerTextSize.width >= MediaQuery.of(context).size.width - 7;
}

Size _textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
