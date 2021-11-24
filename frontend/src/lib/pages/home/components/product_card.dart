import 'package:TonalCreamAssistant/utils/hex_color.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String color;

  const ProductCard({Key? key, required this.name, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
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
