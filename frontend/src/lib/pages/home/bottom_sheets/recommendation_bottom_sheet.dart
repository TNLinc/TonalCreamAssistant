import 'package:TonalCreamAssistant/models/color.dart';
import 'package:TonalCreamAssistant/pages/home/components/color_card.dart';
import 'package:TonalCreamAssistant/pages/home/components/recommendation_list.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'base_bottom_sheet.dart';

class RecommendationBottomSheet extends StatefulWidget {
  final String host;
  final Function(Map<String, dynamic>) notifyParent;
  final ColorRead dataColor;

  const RecommendationBottomSheet(
      {Key? key,
      required this.dataColor,
      required this.host,
      required this.notifyParent})
      : super(key: key);

  @override
  State<RecommendationBottomSheet> createState() =>
      _RecommendationBottomSheetState();
}

class _RecommendationBottomSheetState extends State<RecommendationBottomSheet> {
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
          child: ColorCard(color: widget.dataColor.color),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: BorderedText(
                strokeWidth: 1.2,
                child: Text("Recommended products for you: ",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold)))),
        RecommendationList(
          host: widget.host,
          color: widget.dataColor.color,
        )
      ],
    ));
  }
}
