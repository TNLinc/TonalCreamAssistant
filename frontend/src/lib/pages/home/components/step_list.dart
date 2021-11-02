import 'package:flutter/material.dart';

import 'separator.dart';

class StepList extends StatelessWidget {
  final int activeStep;

  const StepList({Key? key, required this.activeStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Step(number: 1, text: 'Take a photo', active: activeStep == 1),
        const Separator(),
        Step(number: 2, text: 'Wait for result', active: activeStep == 2),
        const Separator(),
        Step(number: 3, text: 'Check recommendations', active: activeStep == 3),
        const Separator(),
        Step(number: 4, text: 'Share results', active: activeStep == 4)
      ],
    );
  }
}

class Step extends StatelessWidget {
  final int number;
  final bool active;
  final String text;

  const Step(
      {Key? key, required this.number, required this.text, this.active = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(children: [
          StepNumber(number: number, active: active),
          Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: active
                      ? Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(shadows: [
                          Shadow(
                              offset: const Offset(0, 3.0),
                              blurRadius: 7.0,
                              color: Theme.of(context).shadowColor),
                        ], fontWeight: FontWeight.bold)
                      : Theme.of(context).textTheme.headline5))
        ]));
  }
}

class StepNumber extends StatelessWidget {
  final int number;
  final bool active;

  const StepNumber({Key? key, required this.number, required this.active})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.headline5!;

    final List<BoxShadow> boxShadow = [];
    if (active) {
      boxShadow.add(BoxShadow(
          color: Theme.of(context).shadowColor,
          blurRadius: 7,
          offset: const Offset(0, 3) // changes position of shadow
          ));
    }

    return Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            color: active ? textStyle.color : null,
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: textStyle.color!),
            boxShadow: boxShadow),
        child: Text(number.toString(),
            style: active
                ? textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).scaffoldBackgroundColor)
                : textStyle));
  }
}
