import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'base_bottom_sheet.dart';

class RecommendationBottomSheet extends StatelessWidget {
  final Map<String, dynamic> data;

  const RecommendationBottomSheet({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
        child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: BorderedText(
                strokeWidth: 1.2,
                child: Text("Your skin color",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold)))),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
          child: Card(
              child: Container(
                  height: 80,
                  width: 200,
                  color: HexColor(data['color']),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(data['color'],
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(fontWeight: FontWeight.bold))))),
        ),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 1000,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Scrollbar(
                child:
                    ListView(scrollDirection: Axis.horizontal, children: const [
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  ),
                  ProductCard(
                    name: 'product name',
                  )
                ]),
              ),
            ),
          ),
        )
      ],
    ));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ProductCard extends StatelessWidget {
  final String name;

  const ProductCard({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(name),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 100,
                  minHeight: 120,
                ),
                color: Colors.grey,
                child: const Icon(Icons.photo),
              ),
            ),
          )
        ],
      ),
    );
  }
}
