import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseBottomSheet extends StatelessWidget {
  final Widget child;

  const BaseBottomSheet({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return BottomSheet(
        elevation: 3,
        enableDrag: false,
        constraints: BoxConstraints(
          maxHeight: 0.5.sh,
          minHeight: 0.5.sh,
        ),
        builder: (BuildContext context) {
          return ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).bottomAppBarColor,
                ),
                child: child,
              ));
        },
        onClosing: () {},
      );
    });
  }
}