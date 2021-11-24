import 'package:TonalCreamAssistant/utils/hex_color.dart';
import 'package:flutter/material.dart';

class ColorCard extends StatelessWidget {
  final String color;

  const ColorCard({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            height: 80,
            width: 200,
            color: HexColor(color),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(color,
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold)))));
  }
}
