import 'package:flutter/material.dart';

class BaseBottomSheet extends StatelessWidget {
  final Widget child;

  const BaseBottomSheet({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      elevation: 3,
      backgroundColor: Theme.of(context).bottomAppBarColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (BuildContext buildContext) {
        return LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
              height: MediaQuery.of(context).size.height /
                  (constraints.maxWidth > 400 ? 2 : 2.65),
              width: double.infinity,
              child: child);
        });
      },
      onClosing: () {},
    );
  }
}
